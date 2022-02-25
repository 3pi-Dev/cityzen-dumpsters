'use strict';

// MapCtrl Controller
angular.module('smartMeters').controller('MapCtrl', function($scope, $state, $log, Data, Leaflet, $timeout, $compile, Log, $translate) {

    $log.info('Map Controller loaded!');

    let leaf = Leaflet;
    let map = {};
    let mapTiles = {};
    let mapBounds = [];
    let mc = leaf.setcluster();
    let blockMarkers = leaf.layerGroup();

    let tr = {};

    let init = function () {

        $translate(['mp_type','mp_address','mp_devices','mp_add','mp_remove','mp_update']).then(function (trans) {
            tr = trans;

            map = leaf.showmap('map',[39.5203614,22.6116068],7,true);
            mapTiles = leaf.tilesControl(map);

            if ($scope.user.type != 2) {
                map.on('contextmenu', function(e) {
                    let html = '<div class="btn-group-vertical btn-group-sm">'+
                                    '<button class="btn btn-default" ng-click="addEntity('+[e.latlng.lat,e.latlng.lng]+')"><i class="fas fa-plus-square text-success"></i> '+tr.mp_add+'</button>'+
                                '</div>';
                    let linkFn = $compile(html);
                    let content = linkFn($scope);
                    let popup = leaf.popup(map,e.latlng,content[0]);
                });
            }

            _.forEach($scope.blocks, function(v,k) {
                let tooltip = '<div class="panel panel-default">'+
                                '<div class="panel-heading"><h3 class="panel-title">'+v.description+'</h3></div>'+
                                '<div class="panel-body">'+
                                    '<b>'+tr.mp_type+':</b> <em>'+$scope.entType(v.type)+'</em><br>'+
                                    '<b>'+tr.mp_address+':</b> <em>'+v.address+'</em><br>'+
                                    '<b>'+tr.mp_devices+':</b> <em>'+v.children+'</em>'+
                                '</div>'+
                            '</div>';
                
                v.marker = leaf.setmarker([v.lat,v.lng],tooltip,v.type,v.type==9?v.children:null,v.type==9?v.free:null);
                v.marker.on('click',function(){$scope.openSettings(v);});
                leaf.addLayer(blockMarkers,v.marker);
                if ($scope.user.type != 2) {
                    v.marker.on('contextmenu',function(e){
                        let html = '<div class="btn-group-vertical btn-group-sm">'+
                                        '<button class="btn btn-default" ng-click="addEntity('+[e.latlng.lat,e.latlng.lng]+')"><i class="fas fa-plus-square text-success"></i> '+tr.mp_add+'</button>'+
                                        '<button class="btn btn-default" ng-click="updateEntity('+v.id+')"><i class="fas fa-pen-square text-primary"></i> '+tr.mp_update+'</button>'+
                                        '<button class="btn btn-default btn-block" ng-click="removeEntity('+v.id+')"><i class="fas fa-minus-square text-danger"></i> '+tr.mp_remove+'</button>'+
                                    '</div>';
                        let linkFn = $compile(html);
                        let content = linkFn($scope);
                        let popup = leaf.popup(map,e.latlng,content[0]);
                    });
                }
            });

            leaf.addLayer(mc,blockMarkers);
            leaf.addLayer(map,mc);

            mapBounds = leaf.getBounds(mc);
            leaf.fitLayers(map,mapBounds);
        }, function (err) {$log.error('Translation error!',err);})
    }

    $scope.filters.filterMap = function (markers) {
        
        leaf.clearCluster(mc);
        leaf.clearLayers(blockMarkers);
        leaf.addLayers(blockMarkers,markers);
        leaf.addLayer(mc,blockMarkers);
    }

    $scope.addEntity = function (lat,lng) {
        
        $state.go('meters',{lat: lat,lng: lng});
    }

    $scope.updateEntity = function (id) {
        
        $state.go('meters',{entity: id});
    }

    $scope.removeEntity = function (id) {
        
        leaf.closePopup(map);
        let index = _.findIndex($scope.blocks, ['id',id]);
        let entity = _.find($scope.blocks, ['id',id]);
        Data.deleteEntity(id).then(function (res) {
            leaf.removeLayer(mc,entity.marker);
            _.pullAt($scope.blocks, [index]);
            Log.add('Entity deleted with id: '+id);
        }, function (err) {
            $log.error(err);
            alert('Error, delete not available!');
        });
    }

    if ($scope.status.dataReady) {init();}
    $scope.$on('dataReady', function(e) {init();});
    $scope.$on('moveToBlock', function(e,block) {
        leaf.moveTo(map,[block.lat,block.lng]);
    });
});