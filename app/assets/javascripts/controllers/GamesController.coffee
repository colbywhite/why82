controllers = angular.module('controllers')

controllers.controller("GamesController", ['$scope', '$routeParams', '$location', 'Game'
  ($scope, $routeParams, $location, Game)->
    $scope.games = []
    $scope.count = 0

    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    $scope.query = (ht)->
      $location.path("/").search('home_teams', ht)

    $scope.loading = true
    if($routeParams.home_teams)
      Game.query('home_teams[]': $routeParams.home_teams, resultCallback)
    else
      Game.query(resultCallback)
])