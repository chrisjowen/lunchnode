app = angular.module('lunchy', [
    'ngRoute',
    'restangular',
    'google-maps',
    'facebook',
    'ui.gravatar',
    'ui.router',
    'ngAutocomplete',
    'LocalStorageModule'
    ])
    .config ($routeProvider, FacebookProvider, RestangularProvider, $stateProvider, $urlRouterProvider) ->

      $urlRouterProvider.otherwise("/")

      $stateProvider.route = (state, url, template, controller) ->
        options = {templateUrl : template}
        options.controller =  controller if controller?
        options.url = url if url?

        @.state state, options

      $stateProvider.state 'lunch.info',
          templateUrl: "lunch/info/index.html"
      $stateProvider.state 'lunch.invited',
        templateUrl: "lunch/coming/index.html"


#      $stateProvider.state 'lunch.search',
#        templateUrl: "lunch/search/index.html"

      FacebookProvider.init('522937244421998');
      RestangularProvider.setBaseUrl('api')


window.app = app