class LunchSearch extends Angular
  @inject '$scope', 'LunchApi', 'Restangular'
  @directive app,
      restrict: 'E'
      replace: true
      templateFolder: 'lunch/'
      scope:
        select : '&'

  initialize: ->
    @$scope.model = {}
    @Restangular.one("categories").get().then((categories) => @$scope.model.categories=categories)
    @$scope.criteria =
        ll : "51.54139,-0.06916"


  events: ->
    search : @search
    selectVenue : @selectVenue

  selectVenue: (venue) =>
    @$scope.select(venue)
#    @LunchApi.one(venue.id).then((restaurant) => @$scope.model.selected = restaurant)

  search: () =>
    @LunchApi.search(@$scope.criteria).then((results) => @$scope.model.results = results)


class LunchApi
    constructor : (@Restangular) ->
    search: (criteria) => @Restangular.one("venue").post("search", {criteria : criteria })
    one: (id) => @Restangular.one("venue", id).get()

app.factory 'LunchApi', (Restangular) ->  new LunchApi(Restangular)