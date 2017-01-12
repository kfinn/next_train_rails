require 'clockwork'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
include Clockwork

every 10.seconds, 'update_departures_channel' do
  ActionCable.server.broadcast '', DeparturesCollection.all
end
