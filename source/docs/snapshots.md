title: Aggregate snapshots
---

Aggregate snapshots allow you to store the state of aggregate instances manually and/or at given version intervals. This allows for more efficient loading of aggregate instances with a large number of commits.

## Defining a SnapshotStore

```typescript
import {AwsSnapshotStore} from '@ddes/aws-store'

export default new AwsEventStore({
  bucketName: `ddes-snapshots`,
  keyPrefix: 'snapshots/',
  manageBucket: true,
})
```

## Configure Aggregate class to use snapshots

```typescript
class MyAggregate extends Aggregate {
  // ...

  static snapshotStore = mySnapshotStore
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

## Using local S3

### Running docker container

```bash
# Start local S3
docker run --rm -d --name s3 -p 5000:5000 skalar/fakes3 \
  s3rver --hostname 0.0.0.0 --port 5000 --directory /tmp/s3 --silent

# Stop local S3
docker kill s3
```

### Configuration
```typescript
import {AwsSnapshotStore} from '@ddes/aws-store'

export default new AwsSnapshotStore({
  tableName: `ddes-main`,

  dynamodbClientConfiguration: {
    endpoint: 'http://localhost:8000',
    region: 'us-east-1',
    accessKeyId: 'test',
    secretAccessKey: 'test',
  },
})
```

See [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_aws_store.awseventstore.html) for details.
