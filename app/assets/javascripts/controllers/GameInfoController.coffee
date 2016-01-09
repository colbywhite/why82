controllers = angular.module('controllers')

controllers.controller("GameInfoController", ['$scope', '$rootScope', '$location', '$routeParams', 'Game'
  ($scope, $rootScope, $location, $routeParams, Game)->
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

    getInfo = (date = null) ->
      Game.info({season: '2016', start_date: date}, resultCallback)

    # TODO: Remove hardcoded dates and determine the next week's dates
    $scope.next_weeks_days = [
      new Date(2015, 11, 29), # Dec 29, js months start at 0
      new Date(2015, 11, 30)  # Dec 30, js months start at 0
    ]

    $scope.loadDate = (date) ->
      $scope.infoLoading = true
      # TODO: Replace toISOString with something that is more timezone aware, i.e. momentjs
      getInfo(date.toISOString())


    setTimeout(getInfo, 100)
])