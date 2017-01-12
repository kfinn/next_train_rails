App.departures = App.cable.subscriptions.create "DeparturesChannel",
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    $("[data-behavior='departures-table']").html('<p>' + JSON.stringify(data) + '</p>')
