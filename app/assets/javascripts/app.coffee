sked = angular.module('sked', [
  'templates',
  'ngRoute',
  'ngResource',
  'services',
  'bw.paging',
  'controllers'
])

services = angular.module('services', ['ngResource']);

sked.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider)->
    $routeProvider.when('/graded',
      templateUrl: '/templates/graded.html'
    ).when('/',
      templateUrl: '/templates/index.html'
    )
    $locationProvider.html5Mode(true)
])

services.factory('Game', ['$resource',
  ($resource) ->
    $resource('/games.json', {page: 1}, {
        query: { method: 'GET', isArray: false }
    })
])
services.factory('GradedGame', ['$resource',
  ($resource) ->
    $resource('/games/:season/graded.json', {}, {
      query: { method: 'GET', isArray: false }
    })
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