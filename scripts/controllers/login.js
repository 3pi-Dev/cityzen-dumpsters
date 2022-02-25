'use strict';

// MainCtrlController
angular.module('smartMeters').controller('LoginCtrl', function($scope, $state, $location, $log, AuthService, $sessionStorage, Log, $translate, $window, Data) {

    $log.info('Login Controller loaded!');

  	$scope.$session = $sessionStorage;

    $scope.username = '';
    $scope.password = '';

    if ($sessionStorage.lang) {
        $translate.use($sessionStorage.lang);
    } else {
        var detectLang = $window.navigator.language || $window.navigator.userLanguage;
        if(detectLang == 'el' || detectLang == 'el-GR'){$translate.use('el');}else{$translate.use('en');}
        $sessionStorage.lang = $translate.use();
    }

    $scope.submit = function() {

    	AuthService.login($scope.username,$scope.password).then(function (res) {
            $scope.$session.id = res.id;
			$scope.$session.name = res.name;
            $scope.$session.type = res.type;
            $scope.$session.title = res.title;
            $scope.$session.logo = res.logo;
            Log.add('login action');
            Data.initiateHeartbeat();
            $state.go('dashboard');
    	}, function (err) {
    		$log.error(err);
            $translate(['lg_err_msg']).then(function (tr) {
                alert(tr.lg_err_msg);
            }, function (er) {$log.error(er);})
    	})
        return false;
    }

    $scope.changeLanguage = function (lang) {

        if ($scope.$session.lang != lang) {
            $scope.$session.lang = lang;
            $translate.use(lang);
        }
    };
});