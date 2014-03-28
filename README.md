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
Tasks are defined in `/lib/tasks`

Relevent tasks

- `$ rake db:setup` Setup the database
- `$ rake db:reset` Drops all data from the database and loads seeds
- `$ rake courses:parse` Gets courses from `/lib/assets/courses.txt`
