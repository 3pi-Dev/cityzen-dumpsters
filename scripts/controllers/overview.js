'use strict';

 // OverviewCtrl Controller
angular.module('smartMeters').controller('OverviewCtrl', function($scope, $log, $timeout, Data, Log, $translate) {

	$log.info('Overview Controller loaded!');

    let tr = {};

	let init = function () {

		$scope.data = {
			entities: {
				length: 0,
				chart: {
					show: false,
					options: {title: {display: true,text: tr.ov_entPieTitle,position: 'bottom',padding: 10}}
				}
			},
			devices: {
				length: 0,
				chart: {
					show: false,
					options: {title: {display: true,text: tr.ov_devPieTitle,position: 'bottom',padding: 10}}
				}
			},
			users: {
				length: 0
			},
		}

		Data.getProjectInfo().then(function(res){

			// General
			$scope.data.entities.length = res.entities;
			$scope.data.devices.length = res.devices;
			$scope.data.users.length = res.users;

			Data.countEntities().then(function(res){
				$scope.data.entities.info = _.map(res, function(item){
					item.title = $scope.entType(item.type);
					return item;
				});
				$scope.data.entities.chart.data = _.map($scope.data.entities.info, 'count');
				$scope.data.entities.chart.labels = _.map($scope.data.entities.info, 'title');
				$scope.data.entities.chart.show = true;
			}, function(err){
				$log.error(err);
				$scope.data.entities.chart.show = true;
			});

			Data.countDevices().then(function(res){
				$scope.data.devices.info = _.map(res, function(item){
					item.title = $scope.devType(item.type);
					return item;
				});
				$scope.data.devices.chart.data = _.map($scope.data.devices.info, 'count');
				$scope.data.devices.chart.labels = _.map($scope.data.devices.info, 'title');
				$scope.data.devices.chart.show = true;
			}, function(err){
				$log.error(err);
				$scope.data.devices.chart.show = true;
			});
		}, function(err){
			$log.error(err);
		});
	}

	$translate(['ov_entPieTitle','ov_devPieTitle']).then(function (res) {
		tr = res;
		init();
	}, function (err) {$log.error('Translation error!',err);})
});