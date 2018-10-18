---
layout: post
title: "Finding Bugs in Cassandra's Internals with Property-based Testing"
date:   2018-10-17 00:00:00 -0700
author: the Apache Cassandra Community
categories: blog
---

As of September 1st, the Apache Cassandra community has shifted the focus of Cassandra 4.0 development from new feature work to testing, validation, and hardening, with the goal of releasing a stable 4.0 that every Cassandra user, from small deployments to large corporations, can deploy with confidence. There are several projects and methodologies that the community is undertaking to this end. One of these is the adoption of property-based testing, which was [previously introduced here](http://cassandra.apache.org/blog/2018/08/21/testing_apache_cassandra.html). This post will take a look at a specific use of this approach and how it found a bug in a new feature meant to ensure data integrity between the client and Cassandra.

#### Detecting Corruption is a Property

In this post, we demonstrate property-based testing in Cassandra through the integration of the [QuickTheories](https://github.com/ncredinburgh/QuickTheories) library introduced as part of the work done for [CASSANDRA-13304](https://issues.apache.org/jira/browse/CASSANDRA-13304). 

This ticket modifies the framing of Cassandra's native client protocol to include checksums in addition to the existing, optional compression. Clients can opt-in to this new feature to retain data integrity across the many hops between themselves and Cassandra. This is meant to address cases where hardware and protocol level checksums fail (due to underlying hardware issues) — a case that has been seen in production. A description of the protocol changes can be found in the ticket but for the purposes of this discussion the salient part is that two checksums are added: one that covers the length(s) of the data (if compressed there are two lengths), and one for the data itself. Before merging this feature, property-based testing using QuickTheories was used to uncover a bug in the calculation of the checksum over the lengths. This bug could have led to silent corruption at worst or unexpected errors during deserialization at best.

The test used to find this bug is shown below. This example tests the property that when a frame is corrupted, that corruption should be caught by checksum comparison. The test is wrapped inside of a standard JUnit test case but, once called by JUnit, execution is handed over to QuickTheories to generate and execute hundreds of examples. These examples are dictated by the types of input that should be generated (the arguments to `forAll`). The execution of each individual example is done by `checkAssert` and its argument, the `roundTripWithCorruption` function.

<div><div><pre>
@Test
public void corruptionCausesFailure()
{
    qt().withExamples(500)
        .forAll(inputWithCorruptablePosition(),
                integers().between(0, Byte.MAX_VALUE).map(Integer::byteValue),
                compressors(),
                checksumTypes())
        .checkAssert(this::roundTripWithCorruption);
}
</pre></div></div>



The `roundTripWithCorruption` function is a generalization of a unit test that worked similarly but for a single case. It is given an input to transform and a position in the transformed output to insert corruption, as well as what byte to write to the corrupted position. The additional arguments (the compressor and checksum type) are used to ensure coverage of Cassandra's various compression and checksumming implementations.

<div><div><pre>
private void roundTripWithCorruption(Pair<String, Integer> inputAndCorruptablePosition,
                                     byte corruptionValue,
                                     Compressor compressor,
                                     ChecksumType checksum) {
    String input = inputAndCorruptablePosition.left;
    ByteBuf expectedBuf = Unpooled.wrappedBuffer(input.getBytes());
    int byteToCorrupt = inputAndCorruptablePosition.right;
    ChecksummingTransformer transformer = new ChecksummingTransformer(checksum, DEFAULT_BLOCK_SIZE, compressor);
    ByteBuf outbound = transformer.transformOutbound(expectedBuf);

    // make sure we're actually expecting to produce some corruption
    if (outbound.getByte(byteToCorrupt) == corruptionValue)
        return;

    if (byteToCorrupt >= outbound.writerIndex())
        return;
 
    try {
        int oldIndex = outbound.writerIndex();
        outbound.writerIndex(byteToCorrupt);
        outbound.writeByte(corruptionValue);
        outbound.writerIndex(oldIndex);
        ByteBuf inbound = transformer.transformInbound(outbound, FLAGS);

        // verify that the content was actually corrupted
        expectedBuf.readerIndex(0);
        Assert.assertEquals(expectedBuf, inbound);
    } catch(ProtocolException e) {
       return;
    }
}
</pre></div></div>

The remaining piece is how those arguments are generated — the arguments to `forAll` mentioned above. Each argument is a function that returns an input generator. For each example, an input is pulled from each generator and passed to `roundTripWithCorruption`.  The `compressors()` and `checksums()` generators aren't copied here. They can be found in the [source](https://github.com/apache/cassandra/blob/65fb17a88bd096b1e952ccca31ad709759644a1b/test/unit/org/apache/cassandra/transport/frame/checksum/ChecksummingTransformerTest.java#L209-L217) and are based on built-in generator methods, provided by QuickTheories, that select a value from a list of values. The second argument, `integers().between(0, Byte.MAX_VALUE).map(Integer::byteValue)`, generates non-negative numbers that fit into a single byte. These numbers will be passed as the `corruptionValue` argument.

The `inputWithCorruptiblePosition` generator, copied below, generates strings to use as input to the transformation function and a position within the output byte stream to corrupt. Because compression prevents knowledge of the output size of the frame, the generator tries to choose a somewhat reasonable position to corrupt by limiting the choice to the size of the generated string (it's uncommon for compression to generate a larger string and the implementation discards the compressed value if it does). It also avoids corrupting the first two bytes of the stream which are not covered by a checksum and therefore can be corrupted without being caught. The function above ensures that corruption is actually introduced and that corrupting a position larger than the size of the output does not occur.

<div><div><pre>
private Gen<Pair<String, Integer>> inputWithCorruptablePosition()
{
    return inputs().flatMap(s -> integers().between(2, s.length() + 2)
                   .map(i -> Pair.create(s, i)));
}
</pre></div></div>

With all those pieces in place, if the test were run before the bug were fixed, it would fail with the following output.

<div><div><pre>
java.lang.AssertionError: Property falsified after 2 example(s) 
Smallest found falsifying value(s) :-
{(c,3), 0, null, Adler32}

Cause was :-
java.lang.IndexOutOfBoundsException: readerIndex(10) + length(16711681) exceeds writerIndex(15): UnpooledHeapByteBuf(ridx: 10, widx: 15, cap: 54/54)
    at io.netty.buffer.AbstractByteBuf.checkReadableBytes0(AbstractByteBuf.java:1401)
    at io.netty.buffer.AbstractByteBuf.checkReadableBytes(AbstractByteBuf.java:1388)
    at io.netty.buffer.AbstractByteBuf.readBytes(AbstractByteBuf.java:870)
    at org.apache.cassandra.transport.frame.checksum.ChecksummingTransformer.transformInbound(ChecksummingTransformer.java:289)
    at org.apache.cassandra.transport.frame.checksum.ChecksummingTransformerTest.roundTripWithCorruption(ChecksummingTransformerTest.java:106)
    ...
Other found falsifying value(s) :- 
{(c,3), 0, null, CRC32}
{(c,3), 1, null, CRC32}
{(c,3), 9, null, CRC32}
{(c,3), 11, null, CRC32}
{(c,3), 36, null, CRC32}
{(c,3), 50, null, CRC32}
{(c,3), 74, null, CRC32}
{(c,3), 99, null, CRC32}

Seed was 179207634899674
</pre></div></div>

The output shows more than a single failing example. This is because QuickTheories, like most property-based testing libraries, comes with a shrinker, which performs the task of taking a failure and minimizing its inputs. This aids in debugging because there are multiple failing examples to look at often removing noise in the process. Additionally, a seed value is provided so the same series of tests and failures can be generated again — another useful feature when debugging. In this case, the library generated an example that contains a single byte of input, which will corrupt the fourth byte in the output stream by setting it to zero, using no compression, and using Adler32 for checksumming. It can be seen from the other failing examples that using CRC32 also fails. This is due to improper calculation of the checksum, regardless of the algorithm. In particular, the checksum was only calculated over the least significant byte of each length rather than all eight bytes. By corrupting the fourth byte of the output stream (the first length's second-most significant byte not covered by the calculation), an invalid length is read and later used.

#### Where to Find More

Property-based testing is a broad topic, much of which is not covered by this post. In addition to Cassandra, it has been used successfully in several places including [car](https://ieeexplore.ieee.org/document/7107466/) [operating
systems](https://arxiv.org/pdf/1703.06574.pdf) and [suppliers' products](https://youtu.be/hXnS_Xjwk2Y?t=1023), [GNOME Glib](https://dl.acm.org/citation.cfm?id=2034662), [distributed consensus](https://github.com/WesleyAC/raft/tree/master/src), and other [distributed](https://www.youtube.com/watch?v=x9mW54GJpG0) [databases](https://youtu.be/hXnS_Xjwk2Y?t=1382). It can also be combined with other approaches such as fault-injection and memory leak detection. Stateful models can also be built to generate a series of commands instead of running each example on one generated set of inputs. Our goal is to evangelize this approach within the Cassandra developer community and encourage more testing of this kind as part of our work to deliver the most stable major release of Cassandra yet.

