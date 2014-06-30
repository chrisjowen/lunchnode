class SuggestionCarosel extends Angular
  @inject '$scope'
  @directive app,
      restrict: 'E'
      replace: true
      templateFolder: 'lunch/info/'
      scope:
        suggestions : '='

  initialize: ->


