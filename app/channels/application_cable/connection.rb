module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :nothing

    def connect
      self.nothing = ''
    end
  end
end
