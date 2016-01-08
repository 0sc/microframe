# Microframe

[![Code Climate](https://codeclimate.com/github/andela-ooranagwa/microframe/badges/gpa.svg)](https://codeclimate.com/github/andela-ooranagwa/microframe) [![Test Coverage](https://codeclimate.com/github/andela-ooranagwa/microframe/badges/coverage.svg)](https://codeclimate.com/github/andela-ooranagwa/microframe/coverage)

Microframe is a lightweight portable ruby web framework modelled after **[Rails](http://rubyonrails.org/)** and inspired by **[Sinatra](https://github.com/sinatra/sinatra)**. It is an attempt to understand the awesome features of **Rails** by reimplementing something similar from scratch.

Just like **Rails**, **Microframe** is a full a _MVC_ framework complete with it's own custom **ORM**. Also included are common utilities like generators, helpers and other niceties.

## Installation
The prerequist for using **Microframe** is to have `ruby` installed. **Microframe** is developed using **Ruby** version `2.1.7` and as such will require a [ruby setup](https://www.ruby-lang.org/en/downloads/) for use.

With **Ruby** installed, you can install **Microframe** in one of two ways:

Add this line to your application's Gemfile:

```ruby
gem 'microframe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install microframe

## Usage

To create an app using **Microframe**

```
  $ microframe new app_name
```
This will generate the correct files and folder structure required for a `microframe app`. **Microframe** tries to keep to the rails project structure:

```

```

Checkout [Sample checklist app](https://github.com/andela-ooranagwa/checklist_with_microframe) built entirely with **Microframe**.

> Having bug issues?
1. Check the sample app
2. If not sampled: try it the Rails ways
3. If not solved: check the list of outstanding features
4. If not included, raise a github issues

## Features
### ORM
Microframe comes with a nice little **ORM** that closely mimicks **Active Record**. Currently, the **ORM** utilizes `sqlite3` gem to implement support for the `sqlite` `db`.

Some of the missing _AR_ semblance includes using `migrations` to manipulate the `database`. In it's place, `models` are expected to use the `property` keyword to define the nature of their `db table`.

*For custom ORM with migration support check [HanaRecord](https://github.com/andela-iokonkwo/hana_record)*

```ruby
property :id, type: :integer, primary_key: true
property :name, type: :text

create_table
```
>The snippet above represents a table with two columns `id` and `name`. The **id** column is the primary_key of the table and is of type `integer`. The **name** column on the other hand is of type `text`.

The property keyword instructs the **ORM** on the nature of the table to be created. The first argument is the name of the `column` in the `db` followed by the properties such as `type`, `primary_key`, `nullable`, `auto_increment`. These properties except `type` are expected to be either `true` or `false`.

The `create_table` keyword is _very very_ **important** and must come after all the table properties have been defined. It triggers the actual creation of the table.

### Routing
Routes follow the basic **Rails** `routing` pattern. It delivers the expected outcome and support for optional arguments and placeholders.

Sample
```ruby
get "/lists/:list_id/items/:id/edit", to: "items#edit"
post "/lists/:list_id/items", to: "items#create"
patch "/lists/:list_id/items/:id", to: "items#update"
put "/lists/:list_id/items/:id", to: "items#update"
delete "/lists/:list_id/items/:id", to: "items#destroy"
```
### Controllers
Microframe controllers follow **Rails** pattern both in naming and operation. Controllers must inherit from `Microframe::Application`. This makes the following methods available:
`params`, `render`, `redirect`, `session`, `request`.

Controller are expected to have a folder named after them in the `view` directory and within this directory you have `view` files for the various controller actions (except for those that end with a redirect)

### Views
Using `Tilt` gem, **Microframe** has support for `erb` files. **Microframe** implements the `render` method for views. `Render` expects two arguments, the `view` to be rendered and the `view layout`. If no layout is given, the default layout: `application` layout, is rendered. Likewise if no view is given, the default *controller\_named view* is expected. Layouts are expected to be in the `layout` folder.

By default **Microframe**, not unlike Rails, assumes that the view to be rendered is a file named _controller_action.html.erb_ located in a folder within the *controller\_named* folder located in the **views** directory. If not found, it assumes the given path is the absolute path to the file.

If `render` is not called explicitly, implicitly, the default view and layout will be called.

The following resources, `all controller instances variables`, `params` (if available), are accessible in the `views`.

Check [Sample checklist app](https://github.com/andela-ooranagwa/checklist_with_microframe) for examples

#### Redirect
Microframe supports using `redirect` if a `render` is not needed. The `redirect` method expects the full web address to redirect to. While `sessions`, `flash`, and `notice` are still in the works, important _data_ can be passed to the new target as params.

#### Partials
Microframe supports rendering `partials`. This allows common view codes (such as form) to be abstracted to a single file which can be reused within the needed views. Find examples in the [Sample checklist app](https://github.com/andela-ooranagwa/checklist_with_microframe).

Partials also have access to view resources.

#### Helpers
The following `helpers` are available and (pretty much) retain their functionality as seen in **Rails**;
* `link_to`
* `image_tag`
* `javascript_tag`
* `stylesheet_tag`

`form_for` helper is also available. `form_for` takes two `arguments` and a `block`. Within the `block`, the following methods are available: `label`, `textarea`, `text_field`, `checkbox`, `hidden`, `submit`

Currently, the form opening tag is instantiated with the first `call` to a form method. As such, HTML complications might arise if this first call is wrapped in `html tags` such as `div`, `span` etc. For the first call pass the desired `html tag` as part of the argument to the first `form method` called.

### Models
Microframe models should inherit from `Microframe::ORM::Base`. This gives them access to essential `methods` such as `property`, `create_table`, and other `db` related processes.

Each model have a table named after it in the database.

#### Queries
Microframe ORM strive to implement `AR` query style. So you can expect `User.all` to return all the users in the `users table`. Available query methods are:
`all`, `select`, `find`, `find_by`, `where`, `count`, `first`, `last`, `limit`, `order`, `destroy`

It also supports methods chaining; queries like `User.first.name` yields the expected result _the name of the first user entry in the users table_
> In order to accurately support `method chaining`, some **trigger methods** are required by certain methods to execute the chained queries. Queries are only executed when any of these triggers are included in the chain. These triggers are:
* `all`
* `first`
* `last`
* `find`
* `find_by`

> All these methods, internally, use a `fetch` method to trigger the execution of the query. The `fetch` method can be called implicitly for queries that doesn't end with any of the methods.

```ruby
User.all #=> SELECT * FROM users
User.count #=> User.all.size
User.first #=> SELECT * FROM users LIMIT 1
User.select("name, email").fetch #=> SELECT name, email FROM users
User.select("email").where("id > 10").select("name").limit("5").order("name DESC") #=> SELECT email, name FROM users WHERE id > 10 ORDER BY name DESC LIMIT 5
User.find_by(email: "email@email.com") #=> SELECT * FROM users WHERE email = 'email@email.com'
User.select("name").find(11) #=> SELECT name FROM users WHERE id = 11
User.destroy(5) #=> DELETE FROM users WHERE id = 5
```

Aside `find`, `find_by`, `first`and `last` (which return individual data objects) and `count` (which returns an integer), every other query method returns a data collection which responds to normal collection methods such as `each`, `includes?`, `map`, etc

Updating model objects are also supported. Update can be done by using any of either the `update` or `save` method.
```ruby
 User.update(email: "new_email@email.com", name: "New name")
 ```
 This updates the given fields in the model and saves it.

 Using the `save` method allows for the usual `AR` _step by step_ update of an object's field(s). Note that `save` has to be called after making changes to an object's field.
 ```ruby
User.name = "New name"
User.email = "new_email@email.com"
User.save
 ```

#### Relationships
Microframe supports `has_many` and `belongs_to` relation found in `AR`. And yes, they have similar behaviour.
```ruby
property :id, type: :integer, primary_key: true
property :name, type: :text

create_table

has_many :items
```
```ruby
property :id, type: :integer, primary_key: true
property :description, type: :text
property :done, type: :boolean
property :list_id, type: :integer

create_table

belongs_to :list
```

Note that the column for the `foreign key` must be included in the appropriate table. By default the `foreign key`, if not explicitly specified (as in the example above), is assumed to be [tablename]\_id. Explicitly you can define the `foreign_key` as show below:

```ruby
belongs_to :list, foreign_key: "list_id"
```

Sample queries
```ruby
List.first.items #=> Returns all the items belonging to the first list entry.
List.all.first.items.last.name #=> Returns the name of the last item belonging to the first list
Item.find_by(name: "Item name").list #=> Return the list to which the item with the name "Item name" belongs to
```
#### Security
The burden of sanitizing (especially) user inputs lies on the developer. **Microframe ORM** security suite, like a couple of other features, it not robust enough. Plans to implement more security features is certainly on the _Todo list_. For now, I kindly indulge the developer to be awake to this responsibility.

### Generators
**Microframe** uses the [**Thor gem**](https://github.com/erikhuda/thor) to implement `generators` which makes for easy creation of core files required for a **Microframe** project.

Sample usage
```ruby
  $ microframe new [app_name] #=> Creates all the necessary directory for a new microframe app called app_name
```
```ruby
  $ microframe generate model [model_name] column1_name:column1_type column2_name:column1_type #=> creates a model file named model_name within the model directory and defines the property for the given columns using the name and type
```
```ruby
  $ microframe generate controller [controller_name] action1 action2 ... #=> creates a controller file named controller_name_controller.rb within the controller folder and defines the given action within it. It also create the views for the given action(s).
```
```ruby
  $ microframe generate view [controller_name] view1 view2 #=> creates a folder for the given controller in the view directory with the given view files
```
```ruby
  $ microframe server #=> Starts there rackup server. It can be called with optionals arguments to rackup
  $ microframe s
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-ooranagwa/microframe. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

### You can:
* Improve `session` Security
* Implement `cookies`
* Implement `flash` messages and `notice`    
* Implement `nested resources` in Routes
* Implement `before action` for controllers
* Improve `route` matchers
* Implement `generating scaffold`
* Improve `microframe server` to accept `rackup arguments`
* Improve **ORM** security
* Implement modifying tables
* Implement support for more db types

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
