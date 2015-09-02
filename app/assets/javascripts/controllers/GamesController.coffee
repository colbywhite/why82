controllers = angular.module('controllers')

controllers.controller("GamesController", ['$scope', '$rootScope', '$location', '$routeParams', 'Game', 'ParamParser'
  ($scope, $rootScope, $location, $routeParams, Game, ParamParser)->
    $rootScope.away_teams = ParamParser.parseAway($routeParams)
    $rootScope.home_teams = ParamParser.parseHome($routeParams)

    $scope.permalink = () ->
      hLength = $rootScope.home_teams.length
      aLength = $rootScope.away_teams.length
      homeString = "h=#{$rootScope.home_teams.join()}"
      awayString = "a=#{$rootScope.away_teams.join()}"
      path = $location.path()
      if hLength <= 0 and aLength <= 0
        path
      else if hLength <= 0 and aLength > 0  # just away
        "#{path}?#{awayString}"
      else if hLength > 0 and aLength <= 0  # just home
        "#{path}?#{homeString}"
      else  # both
        "#{path}?#{homeString}&#{awayString}"

    resultCallback = (results) ->
      $scope.count = results.length
      $scope.games = results

    $rootScope.refreshGames = () ->
      Game.query(params, resultCallback)

    $scope.games = []
    $scope.count = 0

    $scope.convertTime = (timeStr, shortFormat = true) ->
      format = if shortFormat then '%a %m/%d %l:%M %p' else '%a %b %d %l:%M %p %Z'
      LocalTime.strftime(new Date(timeStr), format)

    params = {}
    params['home_teams[]'] = $scope.home_teams if $scope.home_teams
    params['away_teams[]'] = $scope.away_teams if $scope.away_teams
    Game.query(params, resultCallback)
])
