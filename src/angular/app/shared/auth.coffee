class Auth
  constructor: (@restangular, @Facebook, @Session) ->

  login: (userLoggedIn) =>
    @Facebook.getLoginStatus (response) =>
      if response.status == "connected"
        @_setUserFromFBResponse(response.authResponse, userLoggedIn)
      else
        @Facebook.login (response) =>
          console.log(response)
          @_setUserFromFBResponse(response.authResponse, userLoggedIn)

  isAuthenticated: () =>
    @Session.has("user")

  checkServerSession: () =>
    @restangular.one("session")
      .get()
      .then((user) => @Session.add("user", user))

  account: () =>
    @Session.get("user") if @Session.has("user")

  findOrCreateUserFromAccessToken: (accessToken) =>
    @restangular.one("user").post("create", {accessToken: accessToken})

  _setUserFromFBResponse: (authResponse, userLoggedIn) =>
    @findOrCreateUserFromAccessToken(authResponse.accessToken)
      .then (user) =>
          @Session.add("user", user)
          userLoggedIn(user)

class Session
  constructor: () ->
    @session = {}
  add: (key, item) =>
    @session[key] = item
  get: (key) =>
    @session[key]
  has: (key) =>
    @session[key]?
  destroy: () =>
    @session = {}


app.factory "Session", () -> new Session()
app.factory "Auth", (Restangular, Facebook, Session) -> new Auth(Restangular, Facebook, Session)

app.directive "autoscrollDown", ->
  link: postLink = (scope, element, attrs) ->
    scope.$watch (->
      element.children().length
    ), ->
      $(element).animate
        scrollTop: element.prop("scrollHeight")
      , 1000
