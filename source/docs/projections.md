title: Projections
---

Projections allow us to project data from an event store to other types of stores for optimized querying (e.g. elasticsearch). 

## Defining a MetaStore

DDES needs somewhere to store projection progress. A MetaStore is a basic key/value store and can be used to store metadata for for multiple projections.

```typescript
const metaStore = new AwsMetaStore({
  tableName: 'ddes-meta',
})
```

Like with Store, you need to run setup() before using the MetaStore.

```typescript
await metaStore.setup()
```

## Defining a projection

```typescript
const forumsProjection = new Projection({
  metaStore,
  name: 'forums',
  aggregateClasses: {Forum, ForumThread}
  dependencies: {
    ForumThread: {
      Forum: (forumThread, forum) =>
        forumThread.keyProps.forumId === forum.keyProps.forumId,
    },
  },

  async processEvents(events) {
    // order and dependencies are maintained by DDES,
    // so the the provided events set is safe to process in parallel
  }
})
```

## Projection setup

Before projecting data, the projection needs to be configured.

```typescript
await forumsProjection.setup({
  startsAt: new Date('2018-01-01') // date of the first commit in the store to project
})
```

## Running projector

```typescript
const projector = new Projector([forumsProjection], {store: mainStore}})

projector.start()
```

