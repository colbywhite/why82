controllers = angular.module('controllers')

controllers.controller("GamesController", ['$scope', '$routeParams', 'Game', 'ParamParser'
  ($scope, $routeParams, Game, ParamParser)->
    $scope.away_teams = ParamParser.parseAway($routeParams)
    $scope.home_teams = ParamParser.parseHome($routeParams)
    $scope.games = []
    $scope.count = 0

    $scope.convertTime= (timeStr, shortFormat = true) ->
      format = if shortFormat then '%m/%d %l:%M %p' else '%a %b %d %l:%M %p %Z'
      LocalTime.strftime(new Date(timeStr), format)

    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    params = {}
    params['home_teams[]'] = $scope.home_teams if $scope.home_teams
    params['away_teams[]'] = $scope.away_teams if $scope.away_teams
    Game.query(params, resultCallback)
])