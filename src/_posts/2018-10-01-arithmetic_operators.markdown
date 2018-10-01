---
layout: post
title: "Arithmetic Operators in Cassandra 4.0"
date:   2018-10-01 11:30:00 -0100
author: the Apache Cassandra Community
categories: blog
---

Support for arithmetic operators was finally added to CQL in Cassandra 4.0.

This blog post describes the important things to know about CQL arithmetics operators and how we addressed the non trivial challenges around return types and types inference.
## Operations on numbers

Cassandra supports 5 arithmetic operators on numbers: 

| Operator | Description                         |
| :------: | :---------------------------------: |
|    +     | addition                            |
|    -     | negates operand/subtraction         |
|    *     | multiplication                      |
|    /     | division                            |
|    %     | returns the remainder of a division |

Those operators can be used in the SELECT, INSERT, UPDATE and DELETE statements to perform some computations. For example if you wish to know the percentage of completion of the currently running compactions, you can query the **sstable_tasks** system view using the following query:
```
SELECT keyspace_name, 
       table_name, 
       Task_id,
       (progress * 100) / total AS percentage_of_completion 
FROM system_views.sstable_tasks 
WHERE kind = 'compaction'
ALLOW FILTERING;
```
### The important role of return types 

An important thing to take into account when using operators is the return type of the operation. In Cassandra the return type is based on the type of the operands and can be determined using the following table:

| Left/right   | tinyint  | smallint | int    | bigint | counter | float  | double | varint | decimal |
| :----------: | :------: | :------: | :-----: | :----: | :-----: | :-----: | :------: | :-----: | :-----: |
| **tinyint**  | tinyint  | smallint | int     | bigint | bigint  | float   | double   | varint  | decimal |
| **smallint** | smallint | smallint | int     | bigint | bigint  | float   | double   | varint  | decimal |
| **int**      | int      | int      | int     | bigint | bigint  | float   | double   | varint  | decimal |
| **bigint**   | bigint   | bigint   | bigint  | bigint | bigint  | double  | double   | varint  | decimal |
| **counter**  | bigint   | bigint   | bigint  | bigint | bigint  | double  | double   | varint  | decimal |
| **float**    | float    | float    | float   | double | double  | float   | double   | decimal | decimal |
| **double**   | double   | double   | double  | double | double  | double  | double   | decimal | decimal |
| **varint**   | varint   | varint   | varint  | varint | varint  | decimal | decimal  | varint  | decimal |
| **decimal**  | decimal  | decimal  | decimal | decimal | decimal | decimal | decimal | decimal | decimal |


Based on that table you can see that if the `percentage_of_completion` had been computed as `(progress / total) * 100` instead of as `(progress * 100) / total` the output will always have been a `bigint` equal to `0` or `1`. As `progress` and `total` are both `bigints` the output of the division would have been of type `bigint` and equal to 0 if `progress` was smaller than `total`.

### Type inference

Of course literals also play a role in the selection of the return type. Cassandra will try to infer the type of the literals to determine how the operation must be performed. 

In an expression like `percentage_of_completion`, the only information that C* has to infer the type is its value. 

If the literal is an integer C* will look at it and consider it as an `int`, a `bigint` or a `varint` if the type can hold this value.  For example, in our computation, 100 will be considered as an `int` because the value can fit in a 32-bit signed integer.

For floats, if the value can be converted into a `double` without loss of precision C* will consider them as `doubles` otherwise they will be considered as `decimals`.

If the `percentage_of_completion` had been computed as `(progress * 100.0) / total`, 100.0 would have been considered as a `double` and the `percentage_of_completion` type would also have been a `double`.  
   
Now, in some cases Cassandra knows the return type of the expression and can use it to infer the type of the literals.

If for example we have a table like:
```
CREATE TABLE myTable (pk int, c tinyint, v text, PRIMARY KEY(pk, c));
```
Cassandra will be able to prepare the following query without problem.
```
SELECT * FROM myTable WHERE pk = 2 AND c = 1 + ?;
```
As the `c` column is of type `tinyint`, C* can guess that the binding parameter and the literal would be of the `tinyint` type as only the sum of 2 `tinyints` can return a `tinyint`.

But if you try to prepare the following query:
```
SELECT * FROM myTable WHERE pk = ? + 1 AND c = 1;
```
Cassandra will return an error saying : 
```
Ambiguous '+' operation with args ? and 1: use type casts to disambiguate
```
The problem here is that the binding parameter could have 3 different types (`tinyint`, `smallint` or `int`) and C* does not know which one the user intend to use. 

### Hints and casting to the rescue

To solve type inference problems related to binding parameters Cassandra has support for **type hints**. A type hint is a way to explicitly tell Cassandra what will be the type of the parameter.

For example in our previous example if the binding parameter will be an `int`, the query can be modified as follow:
```
SELECT * FROM myTable WHERE pk = (int) ? + 1 AND c = 1;
```
Type hints can also be used to control the type of a literal. If we go back to the __sstable_tasks__ query. We could have change the type of the `percentage_of_completion` to `decimal` by using a `decimal` type hint in front of the literal: 
```
(progress * (decimal) 100) / total AS percentage_of_completion 
```
Of course the same result could have been reached by casting progress into a decimal:
```
(CAST(progress AS decimal) * 100) / total AS percentage_of_completion 
```
or
```
(CAST(progress AS decimal) / total) * 100 AS percentage_of_completion 
```
as the operation between a `decimal` and a `bigint` will result in a decimal.

### Operator precedence

`*`, `/` and `%` operators have a higher precedence level than `+` and `-` operator. By consequence, they will be evaluated before. If two operators in an expression have the same precedence level, they will be evaluated left to right based on their positions in the expression.

Parentheses can be used to modify the order in which the operations must be performed within an expression. Everything within parentheses will be evaluated first to yield a single value before that value can be used by any operator outside the parentheses. 

For example, it is possible to compute the percentage remaining before completion for the compactions as:
```
(total - progress) * 100 / total AS remaining_percentage 
```
## Operations on timestamps and dates

In version 4.0, CQL also support the addition or subtraction of durations from `timestamps` and `dates`.

If you are working with time series data and use the following table to store your sensor data:
```
CREATE TABLE sensor_data (
    sensor text,
    day date,
    ts timeuuid,
    value double,
    primary key((sensor, day), ts)
) WITH CLUSTERING ORDER BY (ts DESC)  
```      
You can use the following query to retrieve some statistics on the data  from the previous day:
```
SELECT sensor, day, min(value), max(value), avg(value)  
FROM sensor_data
WHERE sensor = ? AND day = currentdate() - 1d; 
 ```
You can express durations as `(quantity unit)+` like `12h30m` where the unit can be:
- `y`: years (12` months)
- `mo`: months (1 month)
- `w`: weeks (7 days)
- `d`: days (1 day)
- `h`: hours (3,600,000,000,000 nanoseconds)
- `m`: minutes (60,000,000,000 nanoseconds)
- `s`: seconds (1,000,000,000 nanoseconds)
- `ms`: milliseconds (1,000,000 nanoseconds)
- `us` or `µs` : microseconds (1000 nanoseconds)
- `ns`: nanoseconds (1 nanosecond)
     
###  What about daylight savings and leap seconds?   

Internally the timestamp and date types store information in UTC time. As UTC does not change with a change of seasons arithmetic operations on timestamps and dates are safe and will always return the expected results. However, be aware that the Java libraries used internally by Cassandra, ignores leap seconds. 

