title: Aggregate instances
---

[Aggregate API docs](https://s3-eu-west-1.amazonaws.com/ddes-docs/latest/classes/_ddes_core.aggregate.html)



## Creating an instance

```typescript
const account = await BankAccount.create({id: 'myid', name: 'Igor'})

// Use default value for id provided in KeySchema
const account = await BankAccount.create({name: 'Igor'})
```

## Loading an instance

```typescript
// with AggregateKey string
const account = await BankAccount.load('myid')

// with AggregateKeyProps
const account = await BankAccount.load({id: 'myid'})

// loading a specific version
const account = await BankAccount.load({
  id: 'myid',
  version: 2
})

// loading aggregate at a specific time
const account = await BankAccount.load({
  id: 'myid',
  time: new Date('2017-01-01')
})

```

## Executing commands

```typescript
const account = await BankAccount.load({id: 'myid'})

// With decorated command / manual VersionConflictError handling
await account.deposit(20)

// With retries for undecorated command
await account.executeCommand({name: 'deposit'}, 20)
```

## Committing without loading instance

When you want to commit events that have happened, you might not care about the current state.
In such cases, you can avoid loading the existing events by using the Aggregate.commit method.

```typescript
await BankAccount.commit({id: '1234'}, [
  {type: 'MoneyDeposited', properties: {amount: 20}},
])
```