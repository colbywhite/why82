controllers = angular.module('controllers')

controllers.controller("GradedGamesController", ['$scope', '$rootScope', '$location', '$routeParams', 'GradedGame'
  ($scope, $rootScope, $location, $routeParams, GradedGame)->
    $scope.simpleTime = (timeStr, shortFormat = true) ->
      LocalTime.strftime(new Date(timeStr), '%l:%M %p')

    $scope.simpleDate = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%a, %b %d')

    $scope.getTimeZone = (timeStr) ->
      LocalTime.strftime(new Date(timeStr), '%Z')


    resultCallback = (results) ->
      $scope.grades = [
        {title: 'A Games', games: results.a},
        {title: 'B Games', games: results.b},
        {title: 'C Games', games: results.c},
        {title: 'D Games', games: results.d}
      ]
      $scope.params = results.params

    GradedGame.query({season: '2016'}, resultCallback)
])