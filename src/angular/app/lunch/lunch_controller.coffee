class LunchController extends Angular
  @route app, "/lunch/:lunch_id"

  @inject '$scope', '$rootScope', '$routeParams', 'Restangular'
  initialize: ->
    @$rootScope.fluid = true
    @lunch_id = @$routeParams.lunch_id
    @Restangular.one("lunch").one("get", @lunch_id).get().then @lunchReceived
    @$scope.state = "viewing"

  events: () =>
    addComment: () =>
      @Restangular.one("comment", "create").post(@lunch_id, @$scope.model.comment).then((comment) => console.log(comment))

    selectVenue: (venue) =>
      @$scope.state = "viewing"
      @Restangular.one("suggestion", "create").post(@lunch_id, {identifier : venue.id}).then((comment) => console.log(comment))

  lunchReceived: (lunch) =>
    @$scope.model = lunch
    @listenForLunchInfo()

  listenForLunchInfo: () =>
    socket = io("http://localhost:9000")
    socket.emit "lunch_feed_requested", @lunch_id
    socket.on "lunch#{@lunch_id}", (message) => @lunchMessageReceived(JSON.parse(message.data))


  lunchMessageReceived: (message) =>
    processors =
      comment: (comment) => @$scope.model.comments.push(comment)
      suggestion: (suggestion) => @$scope.model.suggestions.push(suggestion)
      vote: (vote) => @$scope.model.votes.push(vote)
    @$scope.$apply () =>
      processors[message.type](message.item)

