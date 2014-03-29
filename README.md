# Bear-ballings css

## Models

### System
 - State, one of `open`, `pending`, or `scheduled`

### Course
 - Title
 - Number
 - Department

### User
 -  Has ordered list of bins

### Bin

 - References many courses
   Presented ordered, but order is ignored by the scheduler.

## Rake

Rake is ruby's make.
To see a list of avaliable rake tasts run `$ rake -T`
Custom tasks are defined in `/lib/tasks`

Relevent tasks

| Command    | Desc                                                          |
| ---------- | ------------------------------------------------------------- |
| `test`     | Run Unit, Functional, and unit tests.                         |
| `db:setup` | Setup the database.                                           |
| `db:seed`  | Runs `db/seeds.rb` and populates the database with test info. |
| `db:reset` | Drops all data from the database and loads seeds.             |
