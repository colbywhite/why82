controllers = angular.module('controllers')

controllers.controller("GamesController", ['$scope', '$routeParams', 'Game'
  ($scope, $routeParams, Game)->
    $scope.games = []
    $scope.count = 0

    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    if($routeParams.home_teams)
      Game.query('home_teams[]': $routeParams.home_teams, resultCallback)
    else
      Game.query(resultCallback)
])