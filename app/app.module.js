// Define the 'fengApp' module
angular.module('fengApp',[
	'carLeasing',
]).config(function($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
});
