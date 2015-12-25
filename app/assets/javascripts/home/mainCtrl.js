angular.module('flapperNews')
.controller('MainCtrl', [
  '$scope', 'posts',
  function($scope, posts){
    $scope.posts = posts.posts;
    $scope.addPost = function(){
      if(!$scope.title || $scope.title === '') { return; }
      if(!$scope.body || $scope.body === '') { return; }
        posts.create({
        title: $scope.title,
        body: $scope.body,
        link: $scope.link
      });
      $scope.title = '';
      $scope.body = '';
      $scope.link = '';
    };
    $scope.incrementUpvotes = function(post){
      posts.upvote(post);
    };

    $scope.predicate = '-upvotes';
    $scope.order = function(predicate){
      $scope.predicate = predicate;
    };
}]);