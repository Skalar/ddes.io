title: Defining an aggregate class
---

## Class anatomy

```typescript
import {Aggregate, KeySchema, EventWithMetaData} from '@ddes/core'

class MyAggregate extends Aggregate {
  // The key schema tells DDES how to convert from key properties
  // to a key string and vice-versa.
  static keySchema = new KeySchema(['accountId', 'groupId'])

  // The stateReducer is responsible for producing the aggregate state
  static stateReducer = (state: MyStateType, event: EventWithMetaData) {
    // return updated state
  }
  
  // The static helper method MyAggregate.create() invokes the
  // create instance method with the provided properties.
  // [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_core.aggregate.html) for details.
  async create(props: {accountId: string, groupId: string}) {
    if (this.state) { throw new Error('already exists') }
  
    await this.commit({type: 'SomeEvent', properties: {accountId, groupId}})
  }
 
  async doSomething() {
    // validate that current state allows doSomething to be invoked
    await this.commit({type: 'SomethingWasDone', properties: {hello: 'there'}})
  }

  // .. more aggregate commands
}
```

See [API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_core.aggregate.html) for details.


## BankAccount example

```typescript
import {Aggregate, EventWithMetadata, KeySchema} from '@ddes/core'
import {randomBytes} from 'crypto'

class BankAccount extends Aggregate {
  static store = myStore
  static keySchema = new KeySchema([
    {
      name: 'id',
      value(props: {id: string}) {
        return props.id || randomBytes(8).toString('base64')
      },
    },
  ])

  static stateReducer(state: any, event: EventWithMetadata) {
    switch (event.type) {
      case 'Opened': {
        const {id, name} = event.properties
        return {...state, id, name, balance: 0}
      }

      case 'MoneyDeposited': {
        return {...state, balance: state.balance + event.properties.amount}
      }

      case 'MoneyWithdrawn': {
        return {...state, balance: state.balance - event.properties.amount}
      }

      case 'Frozen': {
        return {...state, frozen: true, freezeReason: event.properties.reason}
      }

      case 'Unfrozen': {
        const {freezeReason, ...restState} = state
        return {...restState, frozen: false}
      }

      case 'ForceDeleted': {
        return null
      }

      default:
        return state
    }
  }

  async create(props: {id: string; name: string}) {
    const {id, name} = props

    if (!name) {
      throw new Error('You must specify a name!')
    }

    if (this.state) {
      throw new Error('Account already exists')
    }

    return await this.commit({
      type: 'Opened',
      properties: {
        id,
        name,
      },
    })
  }

  async withdraw(amount: number) {
    if (this.state.frozen)
      throw new Error(
        `Cannot withdraw money from a frozen account: ${
          this.state.freezeReason
        }`
      )

    if (amount <= 0) throw new Error('The deposit amount must be more than 0')

    if (this.state.balance < amount) throw new Error('Not enough moneys')

    return await this.commit({type: 'MoneyWithdrawn', properties: {amount}})
  }

  async deposit(amount: number) {
    if (this.state.frozen)
      throw new Error(
        `Cannot deposit money to a frozen account: ${this.state.freezeReason}`
      )

    if (amount <= 0) throw new Error('The deposit amount must be more than 0')

    return await this.commit({type: 'MoneyDeposited', properties: {amount}})
  }

  async freeze(reason: string) {
    if (this.state.frozen && this.state.freezeReason === reason) return

    return await this.commit({type: 'Frozen', properties: {reason}})
  }

  async unfreeze() {
    if (!this.state.frozen) return

    return await this.commit({type: 'Unfrozen'})
  }

  async forceDelete() {
    return await this.commit({type: 'ForceDeleted'})
  }
}
```

