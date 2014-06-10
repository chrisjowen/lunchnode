class HomeController extends Angular
  @route app, "/"
  @inject '$scope', '$location','Auth'

  initialize: () ->
    if @Auth.isAuthenticated()
      @userLoggedIn(@Auth.account())
  events: () ->
    login : () => @Auth.login @userLoggedIn

  userLoggedIn: (user) =>
    @$location.path("/lunches")

  
