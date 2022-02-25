'use strict';

// ReportCtrlController
angular.module('smartMeters').controller('ReportCtrl', function($scope, $state, $stateParams, $location, $log, $filter, $timeout, Data, AuthService, $translate) {

    if ($stateParams.reportID != null) {

        $log.info('Reports Controller loaded!');
        
        let tr = {};

        let init = function () {
            
            $scope.currentReport = $filter('filter')($scope.reports, {id: $stateParams.reportID}, true)[0];
            $scope.options = _.union([{id: '0', description: tr.rp_all, meters: []}], $scope.blocks);
            $scope.params = {
                dateFrom: new Date().addDays(-10),
                dateTo: new Date(),
                block: $scope.options[0],
                list: ',,'
            }
            $scope.show = {
                spin: false,
                msg: false,
                data: false
            }

            if ($stateParams.blockID) {
                $scope.params.block = $filter('filter')($scope.options, {id: $stateParams.blockID}, true)[0];
                $scope.getMeters();
            }

            $scope.graph = {
                options: {
                    scales: {
                        yAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: '%'
                            }
                        }],
                        xAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: tr.rp_timeLabel
                            }
                        }]
                    }
                },
                type: 'line',
                series: ['%']
            }
        }

        $scope.getMeters = function () {
            
            Data.getDevicesByEntity($scope.params.block.id).then(function (res) {
                $scope.params.block.meters = _.union([{id: '0', name: tr.rp_all}], res);
                if ($stateParams.meterID) {
                    $scope.params.meter = $filter('filter')($scope.params.block.meters, {code: $stateParams.meterID}, true)[0];
                    $scope.showReport();
                }else {
                    $scope.params.meter = $scope.params.block.meters[0];
                }
            }, function (err) {
                $log.debug(err);
            })
        }

        $scope.showReport = function () {

            $scope.show.spin = true;
            $scope.show.msg = false;
            $scope.show.data = false;

            if ($scope.currentReport.id==2 || $scope.currentReport.id==3 || $scope.currentReport.id==7) {
                if ($scope.params.block.id == 0) {
                    alert(tr.rp_selBlock_msg);
                    $scope.show.spin = false;
                    return false;
                }else {
                    if ($scope.params.meter.id == 0) {
                        alert(tr.rp_selMeter_msg);
                        $scope.show.spin = false;
                        return false;
                    } else {
                        $scope.params.list = $scope.params.meter.id;
                    }
                }
            }else {
                if ($scope.params.block.id == 0) {
                    $scope.params.list = ',,';
                }else {
                    if ($scope.params.meter.id == 0) {
                        $scope.params.list = ',' + _.join(_.map(_.tail($scope.params.block.meters), 'id'), ',') + ',';
                    } else {
                        $scope.params.list = ',' + $scope.params.meter.id + ',';
                    }
                }
            }

            Data.reportData($scope.currentReport,$scope.params).then(function (res) {
                
                if (_.isEmpty(res)) {
                    $timeout(function () {$scope.show.spin = false;$scope.show.msg = true;},1000)
                } else {
                    switch($scope.currentReport.id){
                        case 1:
                        case 4:
                        case 5:
                        case 6:
                        case 7:
                            $scope.data = res;
                            break;
                        case 2:
                        case 3:
                            $scope.graph.data = [_.map(res, 'value')];
                            $scope.graph.labels = _.map(res, 'date');
                            break;
                        default:
                            break;
                    }
                    $timeout(function () {$scope.show.spin = false;$scope.show.data = true;},1000)
                }
            }, function (err) {
                if (err==0) {
                    $log.error(err);
                    $scope.show.spin = false;
                    $scope.show.msg = true;
                } else {
                    $log.error('Fail, error 500!');
                    $scope.logout();
                }
            })
        }

        $scope.export = function () {

            // Export data function
        }

        $scope.toggle = function () {

            $scope.graph.type = $scope.graph.type === 'line' ? 'bar' : 'line' ;
        };

        $translate(['rp_all','rp_timeLabel','rp_selBlock_msg','rp_selMeter_msg','rp_status0','rp_status1']).then(function (res) {
            tr = res;
            init();
        }, function (err) {$log.error('Translation error!',err);})
    } else {$location.path('dashboard');}
});