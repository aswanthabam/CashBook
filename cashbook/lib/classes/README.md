## Storage type:

#### Ledger DB

Stores a ledger in db to store the details of a ledger

The ledger db contains the following details:

- current balance in cash and in bank
- list of ledger entities in that ledger
- list of accounts in that ledger
- notes

#### Entity DB

Contains all entitites

It contains the following details

- amount
- fromBank (bool)
- toAccount (account id)
- datetime
- notes
- id (representing datetime and amount)

#### Account DB

It contains the list of accounts

- Name
- Expence account / earning account
- opening balance
- current balance
- id
- notes
