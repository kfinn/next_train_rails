require 'clockwork'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
include Clockwork

every 15.seconds, 'update_stop_times' do
  StopTimesUpdate.new.notify!
end
