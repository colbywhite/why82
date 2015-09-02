receta = angular.module('receta', [
  'templates',
  'ngRoute',
  'ngResource',
  'services',
  'controllers'
])

services = angular.module('services', ['ngResource']);

receta.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider)->
    $routeProvider.when('/',
      templateUrl: "templates/index.html"
    )
    $locationProvider.html5Mode(true)
])

services.factory('Game', ['$resource',
  ($resource) ->
    $resource('/games.json')
])

services.factory('Team', ['$resource',
  ($resource) ->
    $resource('/teams.json')
])

services.factory('ParamParser',
  () ->
    parseHome: (params) ->
      h = params.h || ''
      if h.length >= 1
        h.split(',')
      else
        []
    parseAway: (params) ->
      a = params.a || ''
      if a.length >= 1
        a.split(',')
      else
        []
)

controllers = angular.module('controllers', [])