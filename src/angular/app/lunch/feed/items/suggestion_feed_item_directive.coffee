class SuggestionFeedItem extends Angular
  @inject '$scope', 'Restangular', '$stateParams', '$state'

  @directive app,
      restrict: 'E'
      replace: true
      templateFolder: 'lunch/feed/items/'
      scope:
        suggestion : '='
        scroll : '&'
        user : '='

  initialize: ->
    @$scope.scroll()
    @$scope.suggestion.voted = @voted()

  events: ->
    vote: @vote
    showVenueDetails: @showVenueDetails

  voted: () =>
    @$scope.suggestion.votes.map((vote) => vote.user.id).indexOf(@$scope.user.id)!=-1

  showVenueDetails: (suggestion) =>
   @$state.go("lunch.venue", {lunchId:@$stateParams.lunchId, venueId: suggestion.identifier  })

  vote: (suggestion) =>
      @Restangular.one("suggestion", "vote").post(@$stateParams.lunchId, {direction : 1, suggestionIdentifier: suggestion.identifier}).then((comment) =>
        suggestion.voted = true
      )

