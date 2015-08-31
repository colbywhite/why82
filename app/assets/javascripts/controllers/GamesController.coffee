controllers = angular.module('controllers')

controllers.controller("GamesController", ['$scope', '$routeParams', 'Game', 'ParamParser'
  ($scope, $routeParams, Game, ParamParser)->
    $scope.away_teams = ParamParser.parseAway($routeParams)
    $scope.home_teams = ParamParser.parseHome($routeParams)
    if $scope.home_teams
      console.log($scope.home_teams)
    $scope.games = []
    $scope.count = 0

    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    if $scope.home_teams or $scope.away_teams
      params = {}
      params['home_teams[]'] = $scope.home_teams if $scope.home_teams
      params['away_teams[]'] = $scope.away_teams if $scope.away_teams
      Game.query(params, resultCallback)
    else
      Game.query(resultCallback)
])