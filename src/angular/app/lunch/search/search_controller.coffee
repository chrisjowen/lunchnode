class SearchController extends Angular
  @inject '$scope' ,'$state', '$stateParams', 'Api'
  @route app, "lunch.search",  "/search"

  initialize: ->
    @lunchId = @$stateParams.lunchId
    @loadLunch()

  events: ->
    search : @search
    selectVenue : @selectVenue
    venueInfo: @venueInfo
    markerClicked : ($markerModel) => @mapMarkerClicked($markerModel) #Weird prop injection

  loadLunch: () =>
    @Api.Lunch.get(@lunchId).then (lunch) =>
      @$scope.model = lunch
      loc = @$scope.model.location.geometry.location
      @$scope.criteria =
        ll : "#{loc.k},#{loc.A}"
      @search({section: 'food', openNow: 1})

  selectVenue: (venue) =>
    venue = {identifier: venue.id, name: venue.name, location: venue.location, category: venue.categories[0]}
    @Api.Lunch.suggestVenue(@lunchId, venue).then () =>
      @$state.go("lunch.feed")

  venueInfo: (venue) =>
    @$state.go("lunch.venue", {lunchId: @lunchId, venueId: venue.id})


  search: (category) =>
    @$scope.criteria.category = category
    @Api.Venue.search(@$scope.criteria, @lunchId).then (results) =>
        @$scope.model.results = results
        @placeMapMarkers(@$scope.model.results)

  mapMarkerClicked: ($markerModel) =>
    el = $("#result_#{$markerModel.id}")
    $("#search-results").scrollTo(el,500)
    el.fadeTo('slow', 0.5).fadeTo('slow', 1.0).fadeTo('slow', 0.5).fadeTo('slow', 1.0)

  placeMapMarkers: (results) =>
    markers = results.map (r) =>
      id:r.id,
      latitude:r.location.lat,
      longitude:r.location.lng,
      title:r.name,
      venue: r

    @$scope.map.markers = markers