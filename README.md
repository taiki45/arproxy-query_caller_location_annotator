# Arproxy::QueryCallerLocationAnnotator
[![Build Status](https://travis-ci.org/taiki45/arproxy-query_caller_location_annotator.svg?branch=master)](https://travis-ci.org/taiki45/arproxy-query_caller_location_annotator)

Append query caller method to each ActiveRecord's query log like:

```
User Load (0.3ms)  SELECT  `users`.* FROM `users` ORDER BY `users`.`id` ASC LIMIT 1 /* app/models/user.rb:3 `xxx` */
```

This library was originally written by Takatoshi Maeda (@TakatoshiMaeda on GitHub).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'arproxy-query_caller_location_annotator'
```

And then execute:

    $ bundle

## Usage
arproxy-query_caller_location_annotator will be setup automatically if you use mysql2 adapter. You can disable it by specifying env var as `DISABLE_QUERY_LOCATION_ANNOTATE=1`.

If you want to setup manually, you can change Gemfile to `require: false` then write a initializer by hand:

```
# In config/initializers/arpoxy.rb
require 'arproxy/query_caller_location_annotator/proxy'

if ::Rails.env.development? || ::Rails.env.test?
  ::Arproxy.configure do |config|
    config.adapter = 'postgresql' # Your database adapter
    config.use ::Arproxy::QueryCallerLocationAnnotator::Proxy
  end

  ::ActiveSupport.on_load :active_record do
    ::Arproxy.enable!
  end
end
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/taiki45/arproxy-query_caller_location_annotator.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
