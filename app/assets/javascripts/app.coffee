receta = angular.module('receta', [
  'templates',
  'ngRoute',
  'ngResource',
  'services',
  'controllers'
])

services = angular.module('services', ['ngResource']);

receta.config(['$routeProvider',
  ($routeProvider)->
    $routeProvider
    .when('/',
      templateUrl: "templates/index.html"
    )
])

services.factory('Game', ['$resource',
  ($resource) ->
    $resource('/games.json')
])

services.factory('Team', ['$resource',
  ($resource) ->
    $resource('/teams.json')
])

controllers = angular.module('controllers', [])