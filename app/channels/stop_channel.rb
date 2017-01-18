class StopChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stop_#{params[:stop]}"
  end
  

  def unsubscribed
  end

  def self.broadcast_to(stop)
    ActionCable.server.broadcast "stop_#{stop.id}", stop.to_json
  end
end
