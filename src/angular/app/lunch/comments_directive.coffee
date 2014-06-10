class Comments extends Angular
  @inject '$scope', 'Restangular', '$routeParams'
  @directive app,
      restrict: 'E'
      replace: true
      templateFolder: 'lunch/'
      scope:
        comments : '='

  initialize: ->
    @$scope.model =
      comments : @$scope.comments

  events: ->
    addComment: () =>
      @Restangular.one("comment", "create").post(@$routeParams.lunch_id, @$scope.model.comment).then((comment) => console.log(comment))

