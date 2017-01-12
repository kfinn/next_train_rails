class DeparturesChannel < ApplicationCable::Channel
  def subscribed
    stream_from ''
  end
end
