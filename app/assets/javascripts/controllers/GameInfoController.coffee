controllers = angular.module('controllers')

controllers.controller("GameInfoController", ['$scope', '$rootScope', '$location', '$routeParams', 'Game'
  ($scope, $rootScope, $location, $routeParams, Game)->
    $scope.simpleTime = (timeStr, shortFormat = true) ->
      moment(timeStr, moment.ISO_8601).format('H:mm')

    $scope.simpleDate = (timeStr) ->
      moment(timeStr, moment.ISO_8601).format('ddd, MMM D')

    $scope.getTimeZone = (timeStr) ->
      # LocalTime can go from a "-05:00" timezone to "CST" (or "CDT")
      # but moment cannot.
      # The reason is the diff between moment#toString and Date#toString.
      # So we'll use LocalTime here.
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

    # TODO: Make array size dynamic
    $scope.next_weeks_days = [
      moment(),
      moment().add(1, 'days'),
      moment().add(2, 'days'),
      moment().add(3, 'days'),
      moment().add(4, 'days'),
      moment().add(5, 'days'),
      moment().add(6, 'days')
    ]

    $scope.loadDate = (date) ->
      $scope.infoLoading = true
      iso8601_string = moment(date).format()
      getInfo(iso8601_string)


    setTimeout(getInfo, 100)
])