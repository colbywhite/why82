receta = angular.module('receta', [
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

receta.config(['$routeProvider',
  ($routeProvider)->
    $routeProvider
    .when('/',
      templateUrl: "templates/index.html"
      controller: 'GamesController'
    )
])

controllers = angular.module('controllers', [])