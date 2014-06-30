class LunchController extends Angular
  @route app, "lunch", "/lunch/:lunchId"
  @inject '$scope', '$rootScope', '$stateParams', '$state', 'Auth', 'Api'
  @secure()

  initialize: ->
    @lunchId = @$scope.lunchId = @$stateParams.lunchId
    @$scope.newFeedItems = 0
    @$scope.feedItems = []

    @$scope.map =
      center:
        latitude:  51.5154985
        longitude: -0.17588420000004135
      zoom: 18
    @loadLunch()
#    @$state.go("lunch.info")

  loadLunch: () =>
    @Api.Lunch.get(@lunchId)
      .then(@initializeDetails)
      .then(@listenForChanges)

  initializeDetails: (lunch) =>
    loc = lunch.location.geometry.location
    @$scope.model = lunch
    @$scope.map.center = {latitude: loc.k, longitude: loc.A};

  listenForChanges: (lunch) =>
    socket = io("http://localhost:9000")
    socket.emit "lunch_feed_requested", @lunchId
    socket.on "lunch#{@lunchId}", (message) => @messageReceived(JSON.parse(message.data))

  messageReceived: (message) =>
    processors =
      suggestions: (suggestion) =>
        suggestion.votes = []
        @$scope.model.suggestions.push(suggestion)
      votes: (vote) =>
        @$scope.model.votes.push(vote)
        suggestion = @$scope.model.suggestions.filter (s) -> s.identifier==vote.suggestionIdentifier
        suggestion[0].votes.push(vote) if suggestion[0]?
        suggestion.voted = true if @scope.user.id == vote.user.id
    @$scope.$apply () =>
      message.new = true
      processors[message.type](message.data) if processors[message.type]?
      message.new = true
      @$scope.newFeedItems = @$scope.newFeedItems+1 unless @$state.current.name=="lunch.feed"
      @$scope.feedItems.push(message)
      setTimeout((() => message.new = false), 100)

