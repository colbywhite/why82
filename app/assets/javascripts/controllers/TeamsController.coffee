controllers = angular.module('controllers')

controllers.controller("TeamsController", ['$scope', '$routeParams', '$location', 'Team'
  ($scope, $routeParams, $location, Team)->
    $routeParams.a = $routeParams.a || ''
    if $routeParams.a.length>1
      $scope.away_teams = $routeParams.a.split(',')
    else
      $scope.away_teams = []

    $routeParams.h = $routeParams.h || ''
    if $routeParams.h.length>1
      $scope.home_teams = $routeParams.h.split(',')
    else
      $scope.home_teams = []

    console.log($scope.home_teams)
    console.log($scope.away_teams)

    $scope.addId = (id, arr) ->
      idx = arr.indexOf(id)
      if idx > -1
        arr.splice(idx, 1) # remove
      else
        arr.push(id)
      console.log(arr)
      $location.path("/").search({
        h: $scope.home_teams.join(),
        a: $scope.away_teams.join()
      })

    $scope.addHome = (id) ->
      $scope.addId(id.toString(), $scope.home_teams)

    $scope.addAway = (id) ->
      $scope.addId(id.toString(), $scope.away_teams)

    resultCallback = (results) ->
      $scope.teams = results

    Team.query(resultCallback)
])