class VenueController extends Angular
  @route app, "lunch.venue", "/:venueId"
  @inject '$scope', '$rootScope', '$stateParams', '$state', 'Auth', 'Api'
  @secure()

  initialize: ->
    @venueId = @$stateParams.venueId
    @lunchId = @$stateParams.lunchId
    @$scope.photos = []
    @$scope.comments = []
    @loadVenue()
    @$scope.venueMap =
      center:
        latitude:  0
        longitude: 0
      zoom: 18
      markers : []
      refresh: false

  events: ->
    selectVenue : @selectVenue

  selectVenue: (venue) =>
    venue = {identifier: venue.id, name: venue.name, location: venue.location, category: venue.categories[0]}
    @Api.Lunch.suggestVenue(@lunchId, venue).then () =>
      @$state.go("lunch.feed")


  loadVenue: () =>
    @Api.Venue.get(@venueId).then (venue) =>
      venuePhotos = venue.photos.groups?[1]
      venueTips = venue.tips.groups?[0]
      @$scope.venueMap.center.latitude = venue.location.lat
      @$scope.venueMap.center.longitude = venue.location.lng
      @$scope.venueMap.refresh =  true

      @$scope.venueMap.markers.push
        id: 1
        latitude: venue.location.lat
        longitude: venue.location.lng

      venue.location.fullAddress = venue.location.formattedAddress.join(",")
      @$scope.photos = venuePhotos.items if venuePhotos?
      @$scope.comments = venueTips.items if venueTips?
      @$scope.venue = venue




