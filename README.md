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

## Api Endpoints

| Url                      | Desc                                                                                        |
| ------------------------ | ------------------------------------------------------------------------------------------- |
| GET `/api/teapot`        | Is a teapot.                                                                                |
| GET `/api/departments`   | List of all departments with courses in the database                                        |
| GET `/api/courses`       | List of all courses, accepts `limit`, `offset`, and `department` params                     |
| POST `/api/login`        | Logs in the first user with username `user_name` NOTE: we'll add passwords later            |
| POST `/api/logout`       | Destroys the user session                                                                   |
| GET `/api/user/courses`  | List of a users current bins and courses.                                                   |
| POST `/api/user/courses` | Add courses and bins to the current user. Accepts `_id`, `to_bin`, and `before_bin` params. |


### POST `/api/user/courses`

* `_id`        - The id of the course to add.
* `to_bin`     - The id of the bin to add the course to.
* `before_bin` - Creates a new bin before the bin with this `_id`, and adds the course to it.

Calling this with just an `_id` will create a new bin at the end of the bins list.
With the `to_bin` parameter the course is added to the provided bin.
With the `before_bin` parameter a new bin is created before the bin found with the passed id,
and the course is added to the new bin. Cannot be called with both `to_bin` and `before_bin`.

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
