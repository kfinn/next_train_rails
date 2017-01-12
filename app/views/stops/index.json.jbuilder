json.array! @stops do |stop|
  json.(stop, :name, :routes_description)
end
