controllers = angular.module('controllers')

controllers.controller("GameInfoController", ['$scope', '$rootScope', '$location', '$routeParams', 'GameInfo'
  ($scope, $rootScope, $location, $routeParams, GameInfo)->
    $scope.simpleTime = (timeStr, shortFormat = true) ->
      LocalTime.strftime(new Date(timeStr), '%H:%M')

    $scope.simpleDate = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%a, %b %d')

    $scope.getTimeZone = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%Z')

    $scope.infoLoading = true

    resultCallback = (results) ->
      $scope.tiers = results.teams
      $scope.updated = $scope.simpleDate(results.updated)
      $scope.params = results.params
      games = results.games
      $scope.grades = [
        {title: 'A Games', games: games.a, desc: 'Tier 1 vs. Tier 1'},
        {title: 'B Games', games: games.b, desc: 'Tier 1 vs. Tier 2'},
        {title: 'C Games', games: games.c, desc: 'Tier 2 vs. Tier 2'},
        {title: 'D Games', games: games.d, desc: 'Everything else'}
      ]
      $scope.infoLoading = false

    query = () ->
      GameInfo.query({season: '2016'}, resultCallback)

    setTimeout(query, 100)
])