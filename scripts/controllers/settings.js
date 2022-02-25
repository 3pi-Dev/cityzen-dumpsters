'use strict';

// SettingsCtrl Controller
angular.module('smartMeters').controller('SettingsCtrl', function($scope, $state, $log, Data, $timeout, $uibModalInstance, $filter, $sessionStorage, AuthService, $location, Log, $anchorScroll, $animate, $translate) {
  
  $log.info('Settings Controller loaded!');

  let tr = {};
  let refreshTimer = {};

  let init = function () {

      $scope.data = {
        currentBlock: $scope.$resolve.block,
        meterCard: [],
        imgSpin: true,
        imgCollapsed: true,
        stops: [],
        newStop: {
          type: '0',
          date: new Date(),
          description: ''
        }
      };

      $scope.options = {
        date: {
          showWeeks: false,
          minDate: new Date(),
          startingDay: 1
        },
        time: {
          showMeridian: false
        },
        line: [],
        bar: [],
        pie: [],
        series: {line: []}
      }

      // Options per device type
      $scope.options.line[20] = {
        animation: {duration: 0,easing: 'linear'},
        scales: {
            yAxes: [{scaleLabel: {display: true,labelString: '%'}}],
            xAxes: [{scaleLabel: {display: false}}]
        },
        elements: {line: {fill: false}}
      };

      $scope.options.series.line[20] = ['%'];
        
      $scope.options.bar[20] = {
        title: {display: true,text: tr.st_barText2,position: 'bottom',padding: 5},
        tooltips: {enabled: true,intersect: false,callbacks: {
          label: function(tooltipItem) {
              if (tooltipItem.datasetIndex==0) {
                return tooltipItem.yLabel + ': ' + tooltipItem.xLabel + ' %';
              } else {
                return tooltipItem.yLabel.split('/')[0]+'/'+(parseInt(tooltipItem.yLabel.split('/')[1])-1) + ': ' + (tooltipItem.xLabel?tooltipItem.xLabel:'-') + ' %';
              }
          }
        }}
      };

      $scope.options.pie[20] = {
        title: {display: true,text: tr.st_pieText,position: 'bottom',padding: 10},
        tooltips: {callbacks: {label: function(tooltipItem,data) {return data.labels[tooltipItem.index] + ': ' + data.datasets[0].data[tooltipItem.index] + ' %';}}},
        plugins: {labels: {render: 'label',fontColor: '#000',position: 'outside'}}
      }
      // ----------

      Data.getDevices($scope.data.currentBlock.id).then(function (resM) {
        $scope.data.currentBlock.meters = resM;
        angular.forEach($scope.data.currentBlock.meters, function(value, key){
          if (!value.hasHistory && $scope.data.currentBlock.type != 9) {
            Data.getDeviceHistory(value.id,value.type).then(function (res) {
              value.historyData = [_.map(res, 'value')];
              value.historyLabels = _.map(res, 'date');
              value.hasHistory = true;
              value.consumption = _.last(value.historyData[0]) - _.head(value.historyData[0]);
            }, function (err) {
              $log.error(err);
              value.hasHistory = true;
              value.historyData = [[]];
            })
          }
        });
      }, function (er) {
        $log.error(er);
        $uibModalInstance.dismiss('cancel');
        AuthService.logout();
      });
  }

  $scope.ok = function () {
    
    $uibModalInstance.close();
  };

  $scope.cancel = function () {

    $uibModalInstance.dismiss('cancel');
  };

  // Devices
    $scope.scroll = function(anchor) {

      $location.hash(anchor);
      $anchorScroll();
      $location.hash('');
      $location.replace();

      var element = angular.element($('#'+anchor));
      $animate.addClass(element, 'on');
      $timeout(function () {$animate.removeClass(element, 'on');},700);
    };

    $scope.changeStatus = function (id,status) {
    
      $log.debug(id,status);
    }
  // ----------

  $scope.$on('$destroy', function() {
      if (!_.isEmpty(refreshTimer)){$timeout.cancel(refreshTimer);}
  });


  $translate(['st_status0','st_status1','st_type1','st_type2','st_type3','st_timeLabel','st_barText1','st_barText2','st_barText3','st_barText4','st_pieText','st_delConfirm_msg']).then(function (res) {
    tr = res;
    init();
  }, function (err) {$log.error('Translation error!',err);})
});
