class LunchesController extends Angular
  @route app, "lunches", "/lunches"
  @inject '$scope', 'Restangular', '$state'
  @secure()

  initialize: ->
    @Restangular.one("lunch").one("today").getList().then((lunches) => @$scope.lunches = lunches)
    @$scope.options = options =
      country: 'gb'

  events: () =>
    createNewLunch: () =>
      @Restangular.one("lunch").post("create", @$scope.model.lunch).then (lunch)=>
        @$state.go("lunch", {'lunchId': lunch._id})
