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
      controller: 'GamesController'
    )
])

services.factory('Game', ['$resource',
  ($resource) ->
    $resource('/games.json')
])

controllers = angular.module('controllers', [])