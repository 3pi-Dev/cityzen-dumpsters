'use strict';

 // UsersCtrl Controller
angular.module('smartMeters').controller('UsersCtrl', function($scope, $log, $filter, Leaflet, $timeout, Data, $sessionStorage, Log, $translate) {

	$log.info('Users Controller loaded!');

    let tr = {}; // translations

	let init = function () {
		
		$scope.currentUser = {};
		$scope.userTypes = [
			{value: 0, text: 'Administrator'},
			{value: 1, text: 'Power User'},
			{value: 2, text: 'User'},
		]; 

		Data.getUsers().then(function (res) {
			$scope.users = _.reject(res, function(item){
				if (item.id == $scope.user.id) {
					$scope.currentUser = item;
					return item;
				}
			});
		}, function (err) {
			$log.error(err);
		})
	}

	$scope.showType = function(type) {

		let selected = _.find($scope.userTypes, ['value', type]);
		return selected?selected.text:'Not set';
	};

	$scope.saveUser = function(data, id) {
		
		angular.extend(data, {id: id});
		if (id == 0) {
			$log.debug('save');
			Data.saveUser(data).then(function (res) {
				if (res.inserted) {
					let temp = $filter('filter')($scope.users, {id: 0}, true)[0];
					temp.id = res.inserted;
					Log.add('add user '+res.inserted);
				} else {
					alert(tr.us_fail_msg);
					$scope.users = _.reject($scope.users, function(item){ return item.id == 0; });
				}
			}, function (usrErr) {
				$log.error(usrErr);
			})
		} else {
			$log.debug('update');
			Data.updateUser(data).then(function (res) {
				if(!res.updated){
					alert(tr.us_fail_msg);
				}else{
					Log.add('update user '+res.updated);
				}
			}, function (usrErr) {
				$log.error(usrErr);
			})
		}
	};

	$scope.afterSaveCurrentUser = function () {

		Data.updateUser($scope.currentUser).then(function (usrRes) {
			if(!usrRes.updated){
				alert(tr.us_fail_msg);
				return 'error';
			}else{
				Log.add('update user '+$scope.currentUser.id);
				return true;
			}
		}, function (usrErr) {
			$log.error(usrErr);
			return 'error';
		})
	}

	$scope.removeUser = function(id) {
		
		Data.deleteUser(id).then(function (res) {
			
			if (res.deleted) {
				$scope.users = _.reject($scope.users, function(item){ return item.id == id; });
				Log.add('delete user '+id);
			}
		}, function (usrErr) {
			$log.error(usrErr);
		})
	};

	$scope.addUser = function() {
		$scope.inserted = {
			id: 0,
			name: '',
			username: '',
			password: '',
			email: '',
			phone: '',
			type: 0
		};
		$scope.users.push($scope.inserted);
	};

	$translate(['us_fail_msg']).then(function (res) {
		tr = res;
		init();
	}, function (err) {$log.error('Translation error!',err);})
});