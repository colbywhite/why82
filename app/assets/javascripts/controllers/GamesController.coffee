controllers = angular.module('controllers')
controllers.controller("GamesController", ['$scope', '$routeParams', '$location', '$resource',
  ($scope, $routeParams, $location, $resource)->
    $scope.search = (ht)-> $location.path("/").search('home_teams', ht)
    Game = $resource('/games.json')
    console.log($routeParams)
    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    if( $routeParams.home_teams)
      Game.query('home_teams[]': $routeParams.home_teams, resultCallback)
    else
      Game.query(resultCallback)
])