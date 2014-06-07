class HomeController extends Angular
  @route app, "/"
  @inject '$scope', '$location', 'Facebook', 'Auth'

  initialize: () ->
    @Auth.currentUser().then(@userLoggedIn, @userNotLoggedIn)

  events: () ->
    login : @login

  login: () =>
    console.log("logging in")
    @Facebook.login (response) =>
      console.log response
      @Auth.newUser(response.authResponse.accessToken).then @userLoggedIn

  userLoggedIn: (user) =>
    @$location.path("/lunches")

  userNotLoggedIn: (error) =>
    @$scope.user = null
  
