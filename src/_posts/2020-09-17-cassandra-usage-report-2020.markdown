---
layout: post
title: "Apache Cassandra Usage Report 2020"
date:   2020-09-17 09:00:00
author: the Apache Cassandra Community
categories: blog
---

Apache Cassandra is the open source NoSQL database for mission critical data. Today the community announced findings from a comprehensive global survey of 901 practitioners on Cassandra usage. It’s the first of what will become an annual survey that provides a baseline understanding of who, how, and why organizations use Cassandra.


> "I saw zero downtime at global scale with Apache Cassandra. That's a powerful statement to make. For our business that’s quite crucial." - Practitioner, London

### Key Themes

**Cassandra adoption is correlated with organizations in a more advanced stage of digital transformation.**

People from organizations that self-identified as being in a “highly advanced” stage of digital transformation were more likely to be using Cassandra (26%) compared with those in an “advanced” stage (10%) or “in process” (5%). 

**Optionality, security, and scalability are among the key reasons Cassandra is selected by practitioners.**

The top reasons practitioners use Cassandra for mission critical apps are “good hybrid solutions” (62%), “very secure” (60%), “highly scalable” (57%), “fast” (57%), and “easy to build apps with” (55%). 

**A lack of skilled staff and the challenge of migration deters adoption of Cassandra.**

Thirty-six percent of practitioners currently using Cassandra for mission critical apps say that a lack of Cassandra-skilled team members may deter adoption. When asked what it would take for practitioners to use Cassandra for more applications and features in production, they said “easier to migrate” and “easier to integrate.”

### Methodology

**Sample.** The survey consisted of 1,404 interviews of IT professionals and executives, including 901 practitioners which is the focus of this usage report, from April 13-23, 2020. Respondents came from 13 geographies (China, India, Japan, South Korea, Germany, United Kingdom, France, the Netherlands, Ireland, Brazil, Mexico, Argentina, and the U.S.) and the survey was offered in seven languages corresponding to those geographies. While margin of sampling error cannot technically be calculated for online panel populations where the relationship between sample and universe is unknown, the margin of sampling error for equivalent representative samples would be +/- 2.6% for the total sample, +/- 3.3% for the practitioner sample, and +/- 4.4% for the executive sample. 

To ensure the highest quality respondents, surveys include enhanced screening beyond title and activities of company size (no companies under 100 employees), cloud IT knowledge, and years of IT experience.

**Rounding and multi-response.** Figures may not add to 100 due to rounding or multi-response questions.

### Demographics

Practitioner respondents represent a variety of roles as follows: Dev/DevOps (52%), Ops/Architect (29%), Data Scientists and Engineers (11%), and Database Administrators (8%) in the Americas (43%), Europe (32%), and Asia Pacific (12%). 

![Cassandra roles](/img/blog-post-usage-report-2020/image1.jpg "image_tooltip")

Respondents include both enterprise (65% from companies with 1k+ employees) and SMEs (35% from companies with at least 100 employees). Industries include IT (45%), financial services (11%), manufacturing (8%), health care (4%), retail (3%), government (5%), education (4%), telco (3%), and 17% were listed as “other.”

![Cassandra companies](/img/blog-post-usage-report-2020/image2.jpg "image_tooltip")

### Cassandra Adoption

Twenty-two percent of practitioners are currently using or evaluating Cassandra with an additional 11% planning to use it in the next 12 months. 

Of those currently using Cassandra, 89% are using open source Cassandra, including both self-managed (72%) and third-party managed (48%). 

Practitioners using Cassandra today are more likely to use it for more projects tomorrow. Overall, 15% of practitioners say they are extremely likely (10 on a 10-pt scale) to use it for their next project. Of those, 71% are currently using or have used it before. 

![Cassandra adoption](/img/blog-post-usage-report-2020/image3.jpg "image_tooltip")

### Cassandra Usage

People from organizations that self-identified as being in a “highly advanced” stage of digital transformation were more likely to be using Cassandra (26%) compared with those in an “advanced” stage (10%) in “in process” (5%).

Cassandra predominates in very important or mission critical apps. Among practitioners, 31% use Cassandra for their mission critical applications, 55% for their very important applications, 38% for their somewhat important applications, and 20% for their least important applications. 


> "We're scheduling 100s of millions of messages to be sent. Per day. If it's two weeks, we're talking about a couple billion. So for this, we use Cassandra." - Practitioner, Amsterdam

![Cassandra usage](/img/blog-post-usage-report-2020/image4.jpg "image_tooltip")

### Why Cassandra?

The top reasons practitioners use Cassandra for mission critical apps are “good hybrid solutions” (62%), “very secure” (60%), “highly scalable” (57%), “fast” (57%), and “easy to build apps with” (55%). 


> “High traffic, high data environments where really you're just looking for very simplistic key value persistence of your data. It's going to be a great fit for you, I can promise that.” - Global SVP Engineering

![Top reasons practitioners use Cassandra](/img/blog-post-usage-report-2020/image5.jpg "image_tooltip")

For companies in a highly advanced stage of digital transformation, 58% cite “won’t lose data” as the top reason, followed by “gives me confidence” (56%), “cloud native” (56%), and “very secure” (56%).

> "It can’t lose anything, it has to be able to capture everything. It can’t have any security defects. It needs to be somewhat compatible with the environment. If we adopt a new database, it can’t be a duplicate of the data we already have.… So: Cassandra." - Practitioner, San Francisco

However, 36% of practitioners currently using Cassandra for mission critical apps say that a lack of Cassandra-skilled team members may deter adoption. 


> “We don’t have time to train a ton of developers, so that time to deploy, time to onboard, that's really key. All the other stuff, scalability, that all sounds fine.” – Practitioner, London

When asked what it would take for practitioners to use Cassandra for more applications and features in production, they said “easier to migrate” and “easier to integrate.”

> "If I can get started and be productive in 30 minutes, it’s a no brainer." - Practitioner, London

### Conclusion

We invite anyone who is curious about Cassandra to test the [4.0 beta release](https://cassandra.apache.org/blog/2020/07/20/apache-cassandra-4-0-beta1.html). There will be no new features or breaking API changes in future Beta or GA builds, so you can expect the time you put into the beta to translate into transitioning your production workloads to 4.0. 

We also invite you to participate in a short survey about [Kubernetes and Cassandra](https://docs.google.com/forms/d/e/1FAIpQLScdoTCMxsDwRzt-U898fVmeksBlAf5fud2GVsGqC0T_IQz2Tg/viewform?usp=sf_link) that is open through September 24, 2020. Details will be shared with the Cassandra Kubernetes SIG after it closes.

### Survey Credits

A volunteer from the community helped analyze the report, which was conducted by ClearPath Strategies, a strategic consulting and research firm, and donated to the community by DataStax. It is available for use under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). 
