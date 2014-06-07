app = angular.module('lunchy', [
    'ngRoute',
    'restangular',
    'google-maps',
    'facebook'
    ])
    .config ($routeProvider, FacebookProvider, RestangularProvider) ->
      $routeProvider.route = (url, template, controller) -> @.when url, {templateUrl : template, controller: controller}
      $routeProvider
#        .route('/lunch/', 'lunch/index.html', 'LunchController')
#        .otherwise { redirectTo: '/' }
      FacebookProvider.init('522937244421998');
      RestangularProvider.setBaseUrl('api')
window.app = app