title: Overview
---

## What is DDES?

**DDES is a JS/TypeScript framework that facilitates Event Sourcing and CQRS using distributed cloud services.**

**DDES aims to minimize the effort required to build and operate systems that use Event Sourcing and CQRS.**

**DDES allows you to:**
* persist and access all relevant events within your domain, in an "immutable" store
* express how to produce meaningful state from those events
* define commands that use the state for validation, and if appropriate, commits events to the store.
* project data to other store types that provide optimized ways of reading the data for specific use cases (e.g. elasticsearch).
* subscribe to events that are committed to the store

## Feature highlights

* Model your domain data in a natural way
* [Access and refer to data at any version or time](aggregate_instances.html#Loading-an-instance)
* [Highly available, secure and scalable](https://aws.amazon.com/dynamodb/details/)
* [Automatic continuous backup with per-second granularity point-in-time restores](https://aws.amazon.com/dynamodb/backup-restore/)
* [Low data storage cost](https://aws.amazon.com/dynamodb/pricing/)
* [Throughput capacity auto scaling](auto_scaling.html)
* [Fast and easy store transformations](store_transformations.html)
* [Event upcasters](upcasters.html)
* Transient commits/events
* Fits well with [GraphQL servers](https://www.apollographql.com/docs/apollo-server/)

## Installation

Node.JS >= 8.10 is required.

``` bash
$ yarn add @ddes/core @ddes/aws-store
```
