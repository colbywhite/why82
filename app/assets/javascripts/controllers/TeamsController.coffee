controllers = angular.module('controllers')

controllers.controller("TeamsController", ['$scope', '$routeParams', '$location', 'Team', 'ParamParser'
  ($scope, $routeParams, $location, Team, ParamParser)->
    $scope.away_teams = ParamParser.parseAway($routeParams)
    $scope.home_teams = ParamParser.parseHome($routeParams)

    $scope.addId = (id, arr) ->
      idx = arr.indexOf(id)
      if idx > -1
        arr.splice(idx, 1) # remove
      else
        arr.push(id)
      $scope.redirect()

    $scope.addHome = (id) ->
      $scope.addId(id.toString(), $scope.home_teams)

    $scope.addAway = (id) ->
      $scope.addId(id.toString(), $scope.away_teams)

    $scope.redirect = () ->
      $location.path("/").search({
        h: $scope.home_teams.join(),
        a: $scope.away_teams.join()
      })


    resultCallback = (results) ->
      $scope.teams = results

    Team.query(resultCallback)
])