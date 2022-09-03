require 'elasticsearch'

client = Elasticsearch::Client.new(
  url: 'http://localhost:9200/',
  cloud_id: 'development:dXMtY2VudHJhbDEuZ2NwLmNsb3VkLmVzLmlvOjQ0MyRhZjE0YjE5NjY4OWM0YjcxYTEzYjM3YmUzNjRlNTAzZSRjZDBjM2I0NWEzZjQ0ZjdiYTU0YmY2M2YxZWIzZGQ4Mw==',
  user: 'elastic',
  password: 'vHgiQoLG9oidcex3GZxx7SBM',
  log: true
)

body = {
  name: "The Hitchhiker's Guide to the Galaxy",
  author: 'Douglas Adams',
  release_date: '1979-10-12',
  page_count: 180
}

client.index(index: 'books', body: body)
id = 'lIOfToEBdS3UNsx7xE6j'
client.get(index: 'books', id: id)

query = {
  query: {
    query_string: {
      query: '*ougl*',
      default_field: 'author'
    }
  }
}
response = client.search(index: 'books', body: query)
puts response['hits']['hits'].map(&:hit['_source'])

## TEST geo_distance

sample = { "my_location": { "lat": 42.7, "lon": 70.25 }, "name": 'smart 1' }
sample_2 = { "my_location": { "lat": 30.7, "lon": 66.25 }, "name": 'smart 2' }

settings = { "settings": { "number_of_shards": 1, "number_of_replicas": 0 },
             "mappings": { "properties":
                                        { "my_location":
                                                        { "type": 'geo_point' } } } }

# se debe agregar una sola vez enp
result = client.indices.create(index: "test_locations", body: settings)

puts result

result_1 = client.index(index: "test_locations", body: sample)

puts result_1

result_2 = client.index(index: "test_locations", body: sample_2)
puts result_2 
