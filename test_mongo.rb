require 'mongo'
require_relative 'initializers/heartbeat_log_subscriber'

subscriber = HeartbeatLogSubscriber.new

client = Mongo::Client.new(
  'mongodb+srv://geoquery:jlnTkXl3hAVTR0At@cluster0.wgbkiy3.mongodb.net/?retryWrites=true&w=majority',
  server_api: { version: '1' },
  database: 'GeoTest'
)

client.subscribe(Mongo::Monitoring::SERVER_HEARTBEAT, subscriber)

# db.collection('geopositions').insert_many([{_id: 1, location: {
#                                             type: 'Point',
#                                             coordinates: [-73.856077, 40.848447]
#                                           } },
#                                            { _id: 2, location: {
#                                             type: 'Point',
#                                             coordinates: [-60.452, 41.6547]
#                                           } },
#                                            { _id: 3, location: {
#                                              type: 'Point',
#                                              coordinates: [-50.077, 44.147]
#                                            } },
#                                            { _id: 4, location: {
#                                              type: 'Point',
#                                              coordinates: [67.111, -20.321]
#                                            } },
#                                            { _id: 5, location: {
#                                              type: 'Point',
#                                              coordinates: [-80.4256, -18.447]
#                                            } }])

collection = client[:geopositions]
# creacion de Index para que acepte query geospatial '2dsphere' ($near, $geometry, $maxDistance)

collection.indexes.create_one({ location: '2dsphere' })

locations = collection.find(
  { 'location':
      { '$near':
          { '$geometry':
              { 'type': 'Point', 'coordinates': [-72.2, 39] },
            '$maxDistance': 2 } } }
)

puts 'locations encontrados'
puts locations.count

locations.each do |doc|
  puts doc
end
