controllers = angular.module('controllers')

controllers.controller("GradedGamesController", ['$scope', '$rootScope', '$location', '$routeParams', 'Game'
  ($scope, $rootScope, $location, $routeParams, Game)->
    $scope.simpleTime = (timeStr, shortFormat = true) ->
      LocalTime.strftime(new Date(timeStr), '%H:%M')

    $scope.simpleDate = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%a, %b %d')

    $scope.getTimeZone = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%Z')

    $scope.gamesLoading = true

    resultCallback = (results) ->
      $scope.grades = [
        {title: 'A Games', games: results.a, desc: 'Tier 1 vs. Tier 1'},
        {title: 'B Games', games: results.b, desc: 'Tier 1 vs. Tier 2'},
        {title: 'C Games', games: results.c, desc: 'Tier 2 vs. Tier 2'},
        {title: 'D Games', games: results.d, desc: 'Everything else'}
      ]
      $scope.params = results.params
      $scope.gamesLoading = false

    query = () ->
      Game.query({season: '2016'}, resultCallback)

    setTimeout(query, 100)
])