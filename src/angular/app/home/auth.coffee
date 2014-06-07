class Auth
  constructor: (@restangular) ->
  currentUser: () =>
    @restangular.one("session").get()
  newUser: (fb_ref) =>
    @restangular.one("user").post("create", {fb_ref: fb_ref})

app.factory "Auth", (Restangular) -> new Auth(Restangular)
