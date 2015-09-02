controllers = angular.module('controllers')

controllers.controller("TeamsController", ['$scope', '$rootScope', '$location', 'Team'
  ($scope, $rootScope, $location, Team)->
    $scope.toggleId = (id, arr) ->
      idx = arr.indexOf(id)
      if idx > -1
        arr.splice(idx, 1) # remove
      else
        arr.push(id)
      $rootScope.refreshGames()

    $scope.addHome = (id) ->
      $scope.toggleId(id.toString(), $rootScope.home_teams)

    $scope.addAway = (id) ->
      $scope.toggleId(id.toString(), $rootScope.away_teams)

    resultCallback = (results) ->
      $scope.teams = results

    Team.query(resultCallback)
])