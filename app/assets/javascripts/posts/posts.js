angular.module('flapperNews')
.factory('posts', ['$http', function($http){
  var o = {
    posts: [],
    upvotes: []
  };
  o.getAll = function() {
    return $http.get('/posts.json').success(function(data){
      angular.copy(data.posts, o.posts);
      angular.copy(data.upvotes, o.upvotes)
    });
  };
  o.create = function(post){
    return $http.post('/posts.json', post).success(function(data){
      o.posts.push(data);
    });
  };


  o.hasUpvoted = function(post) {
      var done = 0;
      angular.forEach(o.upvotes, function(upvote, key){
        if (upvote.post_id == post.id) {
          done = 1;
          return;
        }
      });
      if (done == 1) {
        return 1;
      }else{
        return 0;
      }
  };

  o.upvote = function(post) {
    return $http.put('/posts/' + post.id + '/upvote.json').success(function(data){
      if (data.upvoted != 1) {
        post.upvotes += 1;
      }
      else if (data.upvoted == 1) {
        post.upvotes -= 1;
      }
    });
  };

  o.get = function(id) {
  return $http.get('/posts/' + id + '.json').then(function(res){
    return res.data;
    });
  };

  o.addComment = function(id, comment){
    return $http.post('/posts/' + id + '/comments.json', comment);
  };

  o.upvoteComment = function(post, comment){
    return $http.put('/posts/' + post.id + '/comments/' + comment.id + '/upvote.json')
      .success(function(data){
        if (data.upvoted != 1) {
          comment.upvotes += 1;
        }
        else if (data.upvoted == 1) {
          comment.upvotes -= 1;
        }
      });
  };

  return o;
}]);
