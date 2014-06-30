class CategoryImage extends Angular
  @inject '$scope'
  @directive app,
    restrict: 'E'
    replace: true
    template: '<img src="{{href}}" alt="{{alt}}" />'
    scope:
      category : '='
      size : '='
  initialize: () ->
    category = @$scope.category
    icon = category.icon
    @$scope.href = "#{icon.prefix}#{@$scope.size}#{icon.suffix}"
    @$scope.alt = "#{category.shortName}"



app.factory "Api", ($cacheFactory, localStorageService, Restangular, $q) ->
  class Api
    @cache : $cacheFactory('wtf')

    constructor: () ->


    cacheQMem: (cacheKey, q, transformer = (result) => result) =>
      @cacheQ(cacheKey, q, transformer, false)
    cacheQ: (cacheKey, q, transformer = ((result) => result), persist=true) =>
      deferred = $q.defer()
      promise = deferred.promise
      storage =  localStorageService
      if !persist
        storage = Api.cache
        storage.set = storage.put

      result = storage.get(cacheKey)
      if result?
        deferred.resolve(result)
      else
        promise =  q()
        promise.then((result) => storage.set(cacheKey, transformer(result)))
      promise

  class Lunch extends Api
    @transform: (lunch) =>
      for suggestion in lunch.suggestions
        suggestion.votes = lunch.votes.filter (vote) -> vote.suggestionIdentifier == suggestion.identifier
      lunch

    get: (id) =>
      @cacheQMem("lunch.#{id}", (() => Restangular.one("lunch").one("get", id).get()), Lunch.transform)

    suggestVenue: (lunchId, venue) =>
      Restangular.one("suggestion", "create").post(lunchId, venue)

    comment: (lunchId, comment) =>
      Restangular.one("comment", "create").post(lunchId, comment)

  class Venue extends Api
    get: (venueId) =>
      @cacheQ("venue.#{venueId}", () => Restangular.one("venue").one("index", venueId).get())
    search: (criteria, lunchId) =>
      @cacheQ("venue.search.default.#{lunchId}", () => Restangular.one("venue").post("search", {criteria : criteria }))

  Lunch: new Lunch()
  Venue: new Venue()

