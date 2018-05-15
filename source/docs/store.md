title: Defining a store
---

The store serves as an interface for reading and writing Aggregate commits and snapshots.

## AwsStore

AwsStore is powered by AWS DynamoDB and S3, and currently the only available store class.
See [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_aws_store.awsstore.html) for a complete list of configuration options.

### Minimal example

```typescript
import {AwsStore} from '@ddes/aws-store'

export default new AwsStore({
  tableName: `ddes-main`,

  snapshots: {
    s3BucketName: `ddes-snapshots`,
    manageBucket: true,
  },
})
```

### Local DynamoDB and S3

#### Running docker containers

```bash
# Run local DynamoDB
docker run --rm -d --name ddb -p 8000:8000 socialpoint/dynalite \
  dynalite --port=8000 --createTableMs=1 --deleteTableMs=1 --updateTableMs=1

# Run local S3
docker run --rm -d --name s3 -p 5000:5000 skalar/fakes3 \
  s3rver --hostname 0.0.0.0 --port 5000 --directory /tmp/s3 --silent

# Shutting down containers
docker kill s3 ddb
```

#### Store configuration
```typescript
import {AwsStore} from '@ddes/aws-store'

export default new AwsStore({
  tableName: `ddes-main`,

  snapshots: {
    s3BucketName: `ddes-snapshots`,
    manageBucket: true,
  },

  s3ClientConfiguration: {
    endpoint: 'http://localhost:5000',
    sslEnabled: false,
    s3ForcePathStyle: true,
    accessKeyId: 'test',
    secretAccessKey: 'test',
    region: 'us-east-1',
  },

  dynamodbClientConfiguration: {
    endpoint: 'http://localhost:8000',
    region: 'us-east-1',
    accessKeyId: 'test',
    secretAccessKey: 'test',
  },
})
```
