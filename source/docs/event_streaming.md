title: Event streaming
---

In cases, such as when providing GraphQL subscriptions, you want to be notified when events matching certain criteria are committed to the store.

You accomplish this by using the EventStreamer and EventSubscriber classes provided by the `@ddes/event-streaming` package.

## Installation

```bash
yarn add @ddes/event-streaming
```

## Running server

EventStreamer provides push-style event subscriptions over WebSockets.

```typescript
import {EventStreamer} from '@ddes/event-streaming'

const eventStreamer = new EventStreamer({
  port: 80,
  store: mainStore,
  chronologicalGroups: ['forums'],
  filterAggregateTypes: ['Forum', 'ForumThread']
})

```

## Subscribing to events

EventSubscriber connects to an EventStreamer and yields matching events as they are committed to the store.

```typescript
import {EventSubscriber} from '@ddes/event-streaming'

const events = new EventSubscriber({
  wsUrl: `ws://localhost`,
  events: [
    {
      aggregateType: ['Forum', 'ForumThread']
    }
  ],
})

for await (const event of events) {
  // do something with event
}
```