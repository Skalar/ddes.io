title: Aggregate snapshots
---

Aggregate snapshots allow you to store the state of aggregate instances manually and/or at given version intervals. This allows for more efficient loading of aggregate instances with a large number of commits.

## Configure store for snapshots

```typescript
import {AwsStore} from '@ddes/aws-store'

export default new AwsStore({
  tableName: `ddes-main`,

  snapshots: {
    s3BucketName: `ddes-snapshots`,
    keyPrefix: 'snapshots/',
    manageBucket: true,
  },
})
```

## Configure Aggregate class to use snapshots

```typescript
class MyAggregate extends Aggregate {
  static useSnapshots = true
  static snapshotFrequency = 1000 // snapshot every 1000 versions

  // ...
}
```

## Manually write snapshot

```typescript
await myinstance.writeSnapshot()
```

## Skipping snapshotting when committing

```typescript
myinstance.commit(myEvents, {skipSnapshot: true})
```

See [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_aws_store.awsstore.html) for details.
