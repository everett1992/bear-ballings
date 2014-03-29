# Bear-ballings css

## Getting Started

Run these commands in order to begin development.

| Command           | Desc                                                          |
| ----------------- | ------------------------------------------------------------- |
| `$ bundle`        | Installs dependencies from the Gemfile.                       |
| `$ rake db:setup` | Creates the database and seeds test data from `db/seeds.rb`   |
| `$ rake test`     | Run test suite.                                               |
| `$ rails s`       | Starts the rails server on `localhost:3000`.                  |

`bundle` and `db:setup` will only need to be run the first time you clone
the repository.

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
   (Presented ordered, but order is ignored by the scheduler.)

## Rake

Rake is ruby's make.
To see a list of available rake tasks run `$ rake -T`
Custom tasks are defined in `/lib/tasks`

Relevant tasks

| Command    | Desc                                                          |
| ---------- | ------------------------------------------------------------- |
| `test`     | Run unit, functional, and integration tests.                  |
| `db:setup` | Setup the database.                                           |
| `db:seed`  | Runs `db/seeds.rb` and populates the database with test info. |
| `db:reset` | Drops all data from the database and loads seeds.             |
