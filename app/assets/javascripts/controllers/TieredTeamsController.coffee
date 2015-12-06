controllers = angular.module('controllers')

controllers.controller("TieredTeamsController", ['$scope', '$rootScope', '$location', '$routeParams', 'Team'
  ($scope, $rootScope, $location, $routeParams, Team)->
    resultCallback = (results) ->
      $scope.tiers = results.tiers
      $scope.updated = LocalTime.strftime(new Date(results.updated), '%a, %b %d')

    Team.query({season: '2016'}, resultCallback)
])