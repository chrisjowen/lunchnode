class LunchesController extends Angular
  @route app, "/lunches"
  @inject '$scope', 'Restangular'
  @secure()

  initialize: ->
    @Restangular.one("lunch").getList().then((lunches) => @$scope.lunches = lunches)
  events: () =>
    createNewLunch: () =>
      @Restangular.one("lunch").post("create", @$scope.model.lunch).then((lunch)=> @$scope.lunches.push(lunch))