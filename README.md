# Dynamodb::Exporter

The general way to export or make a backup of data from DynamoDB is to use data pipeline. 

If you want a simple way of extracting the contents of your table to a file at a predetermined rate then this is the gem for you.

The contents of the table is exported to file with each line representing a row in the table.

## Installation

Add this line to your application's Gemfile:

    gem 'dynamodb-exporter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamodb-exporter

## Usage

You need to make sure that your credentials are set in the ENV variables before running the app:

```bash
AWS_ACCESS_KEY_ID='bob'
AWS_SECRET_ACCESS_KEY='bob'
AWS_REGION='eu-west-1'
```

Currently there's only one command, and as it's a thor app you can use the help method to find out the parameters needed:

```bash
dynamodb-exporter help
```

## Contributing

1. Fork it ( https://github.com/stevenjack/dynamodb-exporter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [kenoir](https://www.github.com/kenoir)
