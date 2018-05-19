title: Event upcasters
---

Despite thoughtful design of your event types, they sometimes need to change to accomodate your evolving system. Event upcasters allow you to do this without transforming the store or adding compatibility handling to your code.

Upcasters are applied when reading events from the store, before they reach your code.

Upcasting an event, bumps its version number, and you are required to specify the most recent version when committing the event in question. If event version is not specified when committing, it is implicitly 1.

## Example scenario

The User Created event has firstName and lastName properties, but realizing that the world doesn't work that way, you want to merge those properties into a single name property.

### Before change

```typescript
class User extends Aggregate {
  static stateReducer(state: any, event: EventWithMetadata) {
    switch (event.type) {
      case 'Created': {
        const {firstName, lastName} = event.properties
        return {firstName, lastName}
      }

      // ...
    }
  }

  async create(props: {firstName: string, lastName: string}) {
    const {firstName, lastName} = props

    await this.commit({type: 'Created', firstName, lastName})
  }
}
```

### After change

```typescript
const myUpcasters = {
  User: {
    Created:
      1: (props) => {
        const {firstName, lastName} = props
        return {name: `${firstName} ${lastName}`}
      }
    }
  }
}

class User extends Aggregate {
  static upcasters = myUpcasters

  static stateReducer(state: any, event: EventWithMetadata) {
    switch (event.type) {
      case 'Created': {
        const {name} = event.properties
        return {firstName, lastName}
      }

      // ...
    }
  }

  async create(props: {name: string}) {
    const {name} = props

    await this.commit({type: 'Created', version: 2, name})
  }
}
```