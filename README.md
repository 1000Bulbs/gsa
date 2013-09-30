# The GSA Ruby Gem

Quickly and easily harness GSA indexing power with one-line feeding, searching, and faceting.

## Installation
```
gem install gsa
```

## Getting Started
Set the base uri to your GSA box
```ruby
GSA.base_uri = 'http://path-to-gsa-box.com/'
```

## Feeding

1.) Structure the records you wish to feed to the GSA as an array of hashes
```ruby
@products = [ 
{ :id => "1", :name => "Foo", :price => 12, :brand => 'BazBrand' },
{ :id => "2", :name => "Bar", :price => 15, :brand => 'BazBrand' }
]
```

2.) Feed the records to the GSA
```ruby
GSA.feed(
  :records         => @products,
  :searchable      => [:name, :price],
  :datasource_name => "Baz",
  :datasource_uri  => "http://your-app-base-url/products",
  :datasource_uid  => "id",
  :delete?         => false
)
```

### Feed Parameters

**Required**

:records
>The records source being pushed to the GSA index

:searchable
>Attributes on the record you want searched when a query is made

:datasource_name
>Name of the datasource on the GSA

:datasource_uri
>The URI for your records source

:datasource_uid
>The unique id of the record source

**Optional**

:delete?
>Determines whether the feed is an "add" or a "delete" feed; defaults to "false"

### Expected Feed result value

If the feed is successful, the feed method will return "Success".

## Searching

To search, simply pass in a query:

```ruby
query = "Foo"
GSA.search( query )
```
To extract the UIDs from the search results, use the uids method on the search results:

```ruby
GSA.uids( search_results )
```

To filter results using GSA filters, pass in an optional 'filters' key-value pair:

```ruby
# gets all search results for 'Foo' where the price is '12'
query   = "Foo"
filters = "price:12"
GSA.search( query, :filters => filters)
```

Multiple filters can be passed in using a '.' in-between filters:

```ruby
filters = "price:12.name:Foo"
```

Multiple key-value pairs can be passed in as optional parameters to override defaults:

```ruby
GSA.search( query, :filters => filters, :num => 100, :sort => 'relevance', :output => 'xml')
```

### Search Parameters

**Required**

query
>The query for the search

Optional Parameters:

:filter
>* Maps to the GSA 'filter' parameter
>* Accepted values: 0, 1, s, p
>* Default value: 0

:getfields
>* Maps to the GSA 'getfields' parameter
>* Pass in the names of specific attributes you want returned with the results
>* Single attribute example: "name"
>* Multiple attribute example: "name.price"
>* Value to return all attributes: "*"
>* Default value: "*"

:sort
>* Maps to the GSA 'sort' parameter
>* Accepted values: 'relevance', 'date'
>* Default value: 'relevance'

:num
>* Maps to the GSA 'num' parameter
>* Use this parameter to limit the number of search results returned
>* Accepted values: 1..1000
>* Default value: 1000

:start
>* Maps to the GSA 'start' parameter
>* Use this parameter alongside 'num' for pagination of search results
>* Accepted values: 0..results_set_last_result
>* Default value: 0 ( starts with first result )

:output
>* Maps to the GSA 'output' parameter.
>* It is not recommended that you change this value from the default
>* Accepted values: 'xml', 'no_dtd_xml'
>* Default value: 'no_dtd_xml'

:filters
>* Maps the the GSA 'requiredfields' parameter
>* Filters search results to conform to specific required attributes
>* Example: 'name:Foo'
>* Example: 'name:Foo.price:12'

## Faceting

To leverage faceting, simply pass in an array of symbols representing the attributes you want
faceting for, alongside the search results you want faceted.

```ruby
categories = [:name, :brand]
facets     = GSA.facet(search_results, categories)

puts facets
# {:name => [["Foo", 1], ["Bar", 1]], :brand => [["BazBrand", 2]]}
```

### Faceting Results

The faceting method yields results in the following format:

```ruby
{
  :category_one =>
    [
      ["Cluster 1", amount_of_records_in_cluster],
      ["Cluster 2", amount_of_records_in_cluster],
      ["Cluster 3", amount_of_records_in_cluster]
    ],
  :category_two =>
    [
      ["Cluster 1", amount_of_records_in_cluster]
    ]
}
```

## Copyright
Copyright (c) 2013 1000Bulbs.com.
See [LICENSE][] for details.

[license]: LICENSE.txt
