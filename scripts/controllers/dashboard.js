'use strict';

// DashboardCtrl Controller
angular.module('smartMeters').controller('DashboardCtrl', function($scope, $state, $uibModal, $location, Leaflet, $log, $sessionStorage, Data, $filter, $timeout, AuthService, $translate, $window) {

    $scope.$session = $sessionStorage;
    if ($scope.$session.id != null) {

        // language detection
        if ($scope.$session.lang) {
            $translate.use($scope.$session.lang);
        } else {
            let detectLang = $window.navigator.language || $window.navigator.userLanguage;
            if(detectLang == 'el' || detectLang == 'el-GR'){$translate.use('el');}else{$translate.use('en');}
            $scope.$session.lang = $translate.use();
        }

        $scope.$state = $state;
        $scope.user = {
            id: $scope.$session.id,
            name: $scope.$session.name,
            type: $scope.$session.type,
            title: $scope.$session.title,
            logo: $scope.$session.logo
        };
        let leaf = Leaflet;
        $scope.status = {
            spin: true,
            search: '',
        };

        Data.refreshTranslations();
        $scope.blocks = [];
        $scope.reports = [];

        $scope.filters = {
            entityType: '-',
            deviceType: '-',
            park: false,
            dump: false
        }

        moment.locale($translate.use());

        let init = function() {
            
            Data.getBlocks().then(function (res) {
                if (res) {
                    $scope.blocks = res;
                } else {
                    alert("Error, no data!");
                }
                
                $scope.reports = Data.getReports();

                $scope.status.dataReady = true;
                $scope.$broadcast('dataReady');
                $scope.status.spin = false;
            }, function (err) {
                $log.error(err);
                $scope.logout();
            })
        }

        $scope.logout = function () {

            Data.cancelHeartbeat();
            AuthService.logout();
        }

        $scope.openSettings = function (item) {
            
            if(item.children > 0){
                let modalInstance = $uibModal.open({
                    animation: true,
                    size: 'xl',
                    templateUrl: 'views/dashboard/settings.html',
                    controller: 'SettingsCtrl',
                    backdrop: 'static',
                    keyboard: false,
                    resolve: {block: function () {return item;}}
                });
            }
        }

        $scope.filterBlocks = function() {

            let filtered = $scope.blocks;
            let markersToShow = [];

            if($scope.filters.dump && filtered.length > 0) {
                Data.getFullDumpEntities().then(function(res){
                    filtered = _.intersectionBy(filtered, res, 'id');
                }, function(err){
                    filtered = [];
                    $log.error(err);
                });
            }

            $timeout(function(){
                markersToShow = _.map(filtered,'marker');
                $scope.filters.filterMap(markersToShow);
            },600);
        }

        $scope.collapse = function () {
            
            if( navigator.userAgent.match(/Android/i) || navigator.userAgent.match(/webOS/i) || navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/BlackBerry/i) || navigator.userAgent.match(/Windows Phone/i)){
                $scope.isCollapsed = true;
            }
        }

        $scope.getResults = function(chars){

            return Data.search(chars).then(function (res) {
                return res;
            }, function (err) {
                $log.error(err);
                return false;
            })
        }

        $scope.afterSearch = function(item){

            $scope.$broadcast('moveToBlock',_.find($scope.blocks, ['id', item.entity]));
        }

        $scope.changeLanguage = function (lang) {

            if ($scope.$session.lang != lang) {
                $scope.$session.lang = lang;
                $translate.use(lang);
                moment.locale($translate.use());
                $translate(['ds_report1','ds_report2','ds_report3','ds_report4','ds_report5','ds_report6']).then(function (tr) {
                    $scope.reports = [
                        {id: 1,title: tr.ds_report1},
                        {id: 2,title: tr.ds_report2},
                        {id: 3,title: tr.ds_report3},
                        {id: 4,title: tr.ds_report4},
                        {id: 5,title: tr.ds_report5},
                        {id: 6,title: tr.ds_report6}
                    ];
                }, function (er) {
                    $log.error('Translation error!',err);
                })
            }
        };

        $scope.isReportActive = function(id){

            if(id==2 || id==6 || id==7){
                return ($scope.status.hydros || $scope.status.pillars || $scope.status.parking);
            }else{
                if(id==4){
                    return $scope.user.type!=2;
                }else{
                    return true;
                }
            }
        }

        init();
    }else{
        $location.path('login');
    }
});