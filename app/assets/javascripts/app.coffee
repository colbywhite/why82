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

services.factory('ParamParser',
  () ->
    parseHome:  (params) ->
      params.h = params.h || ''
      if params.h.length>1
        params.h.split(',')
      else
        []
    parseAway:  (params) ->
      params.a = params.a || ''
      if params.a.length>1
        params.a.split(',')
      else
        []
)

controllers = angular.module('controllers', [])