controllers = angular.module('controllers')

controllers.controller("TieredTeamsController", ['$scope', '$rootScope', '$location', '$routeParams', 'Team'
  ($scope, $rootScope, $location, $routeParams, Team)->
    $scope.teamsLoading = true

    resultCallback = (results) ->
      $scope.tiers = results.tiers
      $scope.updated = LocalTime.strftime(new Date(results.updated), '%a, %b %d')
      $scope.teamsLoading = false

    query = () ->
      Team.query({season: '2016'}, resultCallback)

    setTimeout(query, 100)
])