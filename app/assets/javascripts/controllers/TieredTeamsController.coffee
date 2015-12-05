controllers = angular.module('controllers')

controllers.controller("TieredTeamsController", ['$scope', '$rootScope', '$location', '$routeParams', 'TieredTeams'
  ($scope, $rootScope, $location, $routeParams, TieredTeams)->
    resultCallback = (results) ->
      $scope.tiers = results.tiers
      $scope.updated = LocalTime.strftime(new Date(results.updated), '%a, %b %d')

    TieredTeams.query({season: '2016'}, resultCallback)
])