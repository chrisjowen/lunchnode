class CommentFeedItem extends Angular
  @inject '$scope'
  @directive app,
      restrict: 'E'
      replace: true
      templateFolder: 'lunch/feed/items/'
      scope:
        comment : '='
