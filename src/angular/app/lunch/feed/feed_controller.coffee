class FeedController extends Angular
  @inject '$scope' ,'$state', '$stateParams', 'Api'
  @route app, "lunch.feed",  "/feed"

  initialize: ->
    @lunchId = @$stateParams.lunchId
    @loadLunch()

  loadLunch: () =>
    @Api.Lunch.get(@lunchId).then @initializeFeed

  initializeFeed: (lunch) =>
    @$scope.$safeApply () =>
      while(@$scope.feedItems.length > 0)
        @$scope.feedItems.pop()
      items = []
      for type in ["comments", "suggestions"]
        items = items.concat(
          lunch[type].map((l) =>
            type: type
            data: l
          ))
      @$scope.feedItems.push.apply(@$scope.feedItems,items)
      @$scope.feedItems.sort((a,b) => new Date(a.data.at)-new Date(b.data.at))
    @scrollToEndOfFeeds()
    @$scope.$watch((() => @$scope.feedItems.length), (() => @scrollToEndOfFeeds(500)))

  events: ->
    addComment: @addComment

  addComment: () =>
    @Api.Lunch.comment(@lunchId, @$scope.comment).then () =>
      @$scope.comment.body = null

  scrollToEndOfFeeds: (time) =>
    setTimeout((() => $("#feed-list").scrollTo($("#feed-end"), time)), 100);
    if @$state.current.name=="lunch.feed"
      @$scope.$safeApply () => @$scope.newFeedItems = 0
