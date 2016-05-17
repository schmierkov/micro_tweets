var app = angular.module('tweetsApp', ['ngResource']);

app.provider('Tweet', function() {
  this.$get = ['$resource', function($resource) {
    return $resource("/api/v1/tweets.json", {}, {'query': { method: 'GET' }});;
  }];
});

app.controller('mainController', ['$scope', 'Tweet', function($scope, Tweet) {

  $scope.options = ['Healthcare', 'NASA', 'Open Source'];
  $scope.tweets = [];
  $scope.tweet = Tweet;

  $scope.show_tweets = function(keyword) {
    $scope.keyword = keyword;
    $scope.tweet.query({keyword: keyword}).$promise.then(function (result) {
      $scope.tweets = [];
      angular.forEach(result.tweets, function(data) {
        $scope.tweets.push(data);
      });
    });
  };

  // Init data, so user does not start on empty page
  $scope.show_tweets('Healthcare');
}]);
