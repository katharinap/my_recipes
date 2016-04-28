This app can be used to manage recipes. Eventually the goal is to predict a meal plan on a weekly or monthly basis based on preferences.

## Getting Set Up
The site is built with [Ruby](https://www.ruby-lang.org) on [Rails](http://rubyonrails.org/). Follow these steps to get it running on your local machine:

##### Install software

* If you need to install Ruby, instructions can be found on the [Ruby download page](https://www.ruby-lang.org/en/downloads/). Install the version matching .ruby-version
* If you need to install Bundler, run `gem install bundler`
* Clone the [github repo](git@github.com:katharinap/my_recipes.git)
* `cd` into the project folder and run `bundle install`

##### Populating the database and running the site
* Run `rake db:create`, `rake db:migrate` and `rake db:seed`.
* To load the server, run `rails s`.
* Optional: Start [guard](https://github.com/guard/guard) by running `bundle exec guard`. Code changes are detected automatically by guard and relevant tests are run
* Navigate to `localhost:3000`

#### Troubleshooting

* If you get error `PG::ObjectInUse: ERROR:  database is being accessed by other users` while trying to drop your database,
run `rake postgres:kill_postgres_connections`.
reference: http://stackoverflow.com/questions/2369744/rails-postgres-drop-error-database-is-being-accessed-by-other-users
* if you get error, `role "my_recipes" does not exist `createuser -s -r my_recipes`

## Contributing to the project
* Assign yourself to an issue
* Create a branch using the convention `[issue-number]-issue-description`. 'Example: 34-code-climate-issues'
* Make code changes including necessary tests
* Make incremental commits to make it easier to review PRs
* Include `issue #[number]` in the commit message so it links the commit to the issue.
  * example: '[#34] Fix Codeclimate issues '
* Create a PR and have it reviewed
* Once you have :+1: :ship-it: or any words indicating your PR is good to be merged, merge it to master
* Run tests: 'rake test`
* If all tests pass, push the changes to master

### Creating Issues on Github
* Create new issues and tag them as Bugs or Feature. Provide as much information as possible.

