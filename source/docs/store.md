title: Defining an EventStore
---

The EventStore class serves as an interface for reading and writing Aggregate commits and snapshots.

## AwsEventStore

AwsEventStore is powered by AWS DynamoDB, and currently the only EventStore implementation.

See [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_aws_store.awseventstore.html) for a complete list of configuration options.

### Minimal example

```typescript
import {AwsEventStore} from '@ddes/aws-store'

const mainStore = new AwsEventStore({
  tableName: `ddes-main`
})
```

### Setup

Before the EventStore can be used, you need to set it up.

```typescript
await mainStore.setup()
```

### Using local DynamoDB

#### Running docker container

```bash
# Starting container
docker run --rm -d --name ddb -p 8000:8000 socialpoint/dynalite \
  dynalite --port=8000 --createTableMs=1 --deleteTableMs=1 --updateTableMs=1

# Shutting down container
docker kill ddb
```

#### Configuration
```typescript
import {AwsEventStore} from '@ddes/aws-store'

export default new AwsEventStore({
  tableName: `ddes-main`,

  dynamodbClientConfiguration: {
    endpoint: 'http://localhost:8000',
    region: 'us-east-1',
    accessKeyId: 'test',
    secretAccessKey: 'test',
  },
})
```
