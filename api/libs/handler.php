<?php
    
    date_default_timezone_set('Europe/Athens');

    // 6 hours cookie expiration 21600
    ini_set('session.gc_maxlifetime', 21600);
    session_set_cookie_params(21600);

    // secure cookie only with https
    ini_set('session.cookie_secure',true);
    
    session_start();
    include_once('mssql.php');

    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    class jsonApi{

        private $md,
                $msDB,
                $action,
                $type,
                $project,
                $lastCall;

        function __construct(){

            $this->md = (isset($_REQUEST[act]))?$_REQUEST[act]:null;
            $this->msDB = new mssqlDb();
            $this->type = (isset($_SERVER[REQUEST_METHOD]))?$_SERVER[REQUEST_METHOD]:null;
            $this->action = $_REQUEST;
            $this->project = (isset($_SESSION[project]))?$_SESSION[project]:false;
            $this->lastCall = $_SESSION[LastCall];
        }

        function __destruct() {}
        
        // Requests & Responces
            public function manageData(){
                
                $torun = $this->md;
                if($torun && method_exists(jsonApi,$torun)){
                    $this->$torun();
                }else{
                    $this->fail(400,array(error => 'Nothing Requested!'));
                }
            }

            public function success($data){

                http_response_code(200);
                echo json_encode($data);
            }

            public function fail($code=null,$data=null){

                if ($code) {
                    http_response_code($code);
                    if ($data) {echo json_encode($data);} else {echo null;}
                } else {
                    http_response_code(500);
                    echo null;
                }
            }

            // heartbeat function to keep session alive!
            private function heartbeat(){

                if (isset($_SESSION[project])){
                    $_SESSION[project] = $_SESSION[project];
                    $this->success(true);
                }else{
                    $this->fail();
                }
            }
        // ----------


        // Authentication
            public function checkUser(){

                return ($this->project)?true:false;
            }
        
            private function login(){
                
                $params = array(
                    username => array(varchar,$this->action[username]),
                    password => array(varchar,$this->action[password])
                );

                $this->msDB->execProc('web_checkUser',$params);
                $result = $this->msDB->getData();

                if ($result && $result[id]) {
                    $result[id] = (int)$result[id];
                    $result[type] = (int)$result[type];
                    $result[project] = (int)$result[project];
                    $this->project = $result[project];
                    $_SESSION[project] = $this->project;
                    $this->success(
                        array(
                            id => $result[id],
                            name => $result[name],
                            type => $result[type],
                            title => $result[title],
                        )
                    );
                } else {
                    $this->fail(404);
                }
            }

            private function logout(){
                
                session_unset();
                session_destroy();
                $this->success(true);
            }
        // ----------


        // Users
            private function getUsers(){
                
                $params = array(
                    project => array(int,$this->project)
                );
                $this->msDB->execProc('web_getUsers', $params);

                $data = array();
                while($row=$this->msDB->getData()){
                    $row[id] = (int)$row[id];
                    $row[type] = (int)$row[type];
                    $data[] = $row;
                }
                $this->success($data);
            }
            
            private function insertUser(){
                
                $params = array(
                    username => array(varchar,$this->action[username]),
                    password => array(varchar,$this->action[password]),
                    type => array(int,$this->action[type]),
                    email => array(varchar,$this->action[email]),
                    phone => array(varchar,$this->action[phone]),
                    name => array(varchar,$this->action[name]),
                    project => array(int,$this->project)
                );

                $this->msDB->execProc('web_insertUser',$params);
                $row = $this->msDB->getData();
                $this->success($row);
            }

            private function updateUser(){
                
                $params = array(
                    id => array(int,$this->action[id]),
                    username => array(varchar,$this->action[username]),
                    password => array(varchar,$this->action[password]),
                    type => array(int,$this->action[type]),
                    email => array(varchar,$this->action[email]),
                    phone => array(varchar,$this->action[phone]),
                    name => array(varchar,$this->action[name])
                );

                $this->msDB->execProc('web_updateUser',$params);
                $row = $this->msDB->getData();
                $this->success($row);
            }

            private function deleteUser(){
                
                $params = array(
                    id => array(int,$this->action[id])
                );

                $this->msDB->execProc('web_deleteUser',$params);
                $row=$this->msDB->getData();
                $this->success($row);
            }
        // ----------


        // Logs
            private function getLogs(){
                
                $params = array(
                    user => array(int,$this->action[user])
                );
                $this->msDB->execProc('web_getLogs',$params);

                $data = array();
                while($row=$this->msDB->getData()){$data[] = $row;}
                
                $this->success($data);
            }
            
            private function insertLog(){
                
                $params = array(
                    user => array(int,$this->action[user]),
                    description => array(varchar,$this->action[description])
                );
                
                $this->msDB->execProc('web_insertLog',$params);
            }
        // ----------


        // Entities
            private function getEntities(){
                
                $params = array(
                    project => array(int,$this->project)
                );
                $this->msDB->execProc('web_getEntities',$params);
                
                $data = array();
                while($row=$this->msDB->getData()){
                    $row[id] = (int)$row[id];
                    $row[type] = (int)$row[type];
                    $row[height] = $row[height]?(int)$row[height]:null;
                    $row[lat] = (float)$row[lat];
                    $row[lng] = (float)$row[lng];
                    $data[] = $row;
                }
                
                $this->success($data);
            }

            private function addEntity(){

                $params = array(
                    type => array(int, $this->action[type]),
                    title => array(varchar, $this->action[title]),
                    address => array(varchar, $this->action[address]),
                    lat => array(float, $this->action[lat]),
                    lng => array(float, $this->action[lng]),
                    project => array(int, $this->project),
                    height => array(int, $this->action[height])
                );
                $this->msDB->execProc('web_addEntity',$params);
                $result = $this->msDB->getData();

                if ($result && $result[id]) {
                    $this->success($result);
                } else {
                    $this->fail(400,array('error' => 'Not saved!'));
                }
            }

            private function updateEntity(){

                $params = array(
                    id => array(int, $this->action[id]),
                    type => array(int, $this->action[type]),
                    title => array(varchar, $this->action[title]),
                    address => array(varchar, $this->action[address]),
                    lat => array(float, $this->action[lat]),
                    lng => array(float, $this->action[lng]),
                    height => array(int, $this->action[height])
                );
                $this->msDB->execProc('web_updateEntity',$params);
                $result = $this->msDB->getData();

                if ($result[rows] && $result[rows]==1) {
                    $this->success(true);
                } else {
                    $this->fail(404,array('error' => 'Not updated!'));
                }
            }

            private function deleteEntity(){

                $params = array(id => array(int, $this->action[id]));
                $this->msDB->execProc('web_deleteEntity',$params);
                $result = $this->msDB->getData();

                if ($result[rows] && $result[rows]==1) {
                    $this->success(true);
                } else {
                    $this->fail(404,array('error' => 'Not deleted!'));
                }
            }
        // ----------


        // Devices
            private function getDevices(){
                
                $data = array();
                $params = array(
                    entity => array(int,$this->action[entity])
                );

                $this->msDB->execProc('web_getDevices',$params);
                while($row=$this->msDB->getData()){
                    $row[value] = (float)$row[value];
                    $row[valve] = $row[valve]=='0'?false:true;
                    $row[status] = $row[status]=='0'?false:true;
                    $data[] = $row;
                }
                $this->success($data);
            }

            private function addDevice(){

                $params = array(
                    project => array(int,$this->project),
                    type => array(int,$this->action[type]),
                    entity => array(int,$this->action[entity]),
                    barcode => array(varchar,$this->action[barcode]),
                    mote => array(varchar,$this->action[mote]),
                    ip => array(varchar,$this->action[ip]),
                    erp => array(varchar,$this->action[erp]),
                    provision => array(varchar,$this->action[provision])
                );
                $this->msDB->execProc('web_addDevice',$params);
                $result = $this->msDB->getData();

                if ($result && $result[id]) {
                    $this->success($result);
                } else {
                    $this->fail(400);
                }
            }

            private function updateDevice(){

                $params = array(
                    id => array(int,$this->action[id]),
                    type => array(int,$this->action[type]),
                    entity => array(int,$this->action[entity]),
                    ip => array(varchar,$this->action[ip]),
                    barcode => array(varchar,$this->action[barcode]),
                    mote => array(varchar,$this->action[mote]),
                    descr => array(varchar,$this->action[descr]),
                    erp => array(varchar,$this->action[erp]),
                    provision => array(varchar,$this->action[provision]),
                    oldMeter => array(varchar,$this->action[oldMeter]),
                    oldMeter2 => array(int,$this->action[oldMeter2]),
                    oldValue => array(int,$this->action[oldValue]),
                    comments => array(varchar,$this->action[comments])
                );
                $this->msDB->execProc('web_updateDevice',$params);
                $result = $this->msDB->getData();

                if ($result[rows]==1) {
                    $this->success(true);
                } else {
                    $this->fail(404);
                }
            }

            private function deleteDevice(){

                $params = array(id => array(int, $this->action[id]));
                $this->msDB->execProc('web_deleteDevice',$params);
                $result = $this->msDB->getData();

                if ($result[rows]==1) {
                    $this->success(true);
                } else {
                    $this->fail(404);
                }
            }

            private function search(){

                $params = array(
                    project => array(int,(int)$this->project),
                    part => array(varchar,$this->action[part])
                );
                $this->msDB->execProc('web_wideSearch',$params);

                $data = array();
                while($row=$this->msDB->getData()){
                    $row[id] = (int)$row[id];
                    $row[entity] = (int)$row[entity];
                    $row[description] = ($row[mote]?$row[mote]:'') . ($row[address]?', '.$row[address]:'') . ($row[barcode]?', '.$row[barcode]:'');
                    $data[] = $row;
                }

                $this->success($data);
            }
        // ----------


        // Reports
            private function reportValues(){
                
                $params = array(
                    ids => array(varchar,$this->action[ids]),
                    dateFrom => array(varchar,$this->action[dateFrom]),
                    dateTo => array(varchar,$this->action[dateTo]),
                    project => array(int,$this->project)
                );
                $this->msDB->execProc('web_reportValues',$params);

                $data = array();
                while($row=$this->msDB->getData()){
                    if ($row[date]) {
                        $row[date] = date('d/m/Y H:i',strtotime($row[date]));
                    }
                    $data[] = $row;
                }
                $this->success($data);
            }

            private function reportAllValues(){
                
                $params = array(
                    ids => array(varchar,$this->action[ids]),
                    dateFrom => array(varchar,$this->action[dateFrom]),
                    dateTo => array(varchar,$this->action[dateTo]),
                    project => array(int,$this->project)
                );
                $this->msDB->execProc('web_reportValues_perhour',$params);

                $data = array();
                while($row=$this->msDB->getData()){
                    if ($row[date]) {
                        $row[date] = date('d/m/Y H:i',strtotime($row[date]));
                    }
                    $data[] = $row;
                }
                $this->success($data);
            }

            private function getDeviceStatusHistory(){
                
                $params = array(
                    device => array(int,$this->action[meterID]),
                    dateFrom => array(varchar,$this->action[dateFrom]),
                    dateTo => array(varchar,$this->action[dateTo])
                );
                $this->msDB->execProc('web_getDeviceStatusHistory',$params);

                $data = array();
                while($row=$this->msDB->getData()){
                    if ($row[date]) {$row[date] = date('d-m-Y H:i',strtotime($row[date]));}
                    $row[status] = (int)$row[status];
                    $data[] = $row;
                }
                $this->success($data);
            }

            private function countDevices(){

                $params = array(
                    project => array(int,$this->project)
                );
                $this->msDB->execProc('web_countDevices',$params);
                
                $data = array();
                while($row = $this->msDB->getData()){
                    $data[] = array(
                        type => (int)$row[type],
                        count => (int)$row[count]
                    );
                }
                
                if(sizeof($data) > 0){
                    $this->success($data);
                } else{
                    $this->fail(404);
                }
            }
        // ----------
        

        // Internal functions
            public static function datetime($unixTimestamp){

                return date("Y-m-d H:m:s", $unixTimestamp);
            }

            public static function mobileDatetime($unixTimestamp){

                return date("Y-m-d H:m:s", $unixTimestamp/1000);
            }

            public static function timestamp($string){

                return strtotime($string);
            }

            public static function mobileTimestamp($string){

                return strtotime($string)*1000;
            }

            public function checkIP(){

                $pool = array();
                $ipaddress = '';

                if (getenv('HTTP_CLIENT_IP'))
                    $ipaddress = getenv('HTTP_CLIENT_IP');
                else if(getenv('HTTP_X_FORWARDED_FOR'))
                    $ipaddress = getenv('HTTP_X_FORWARDED_FOR');
                else if(getenv('HTTP_X_FORWARDED'))
                    $ipaddress = getenv('HTTP_X_FORWARDED');
                else if(getenv('HTTP_FORWARDED_FOR'))
                    $ipaddress = getenv('HTTP_FORWARDED_FOR');
                else if(getenv('HTTP_FORWARDED'))
                   $ipaddress = getenv('HTTP_FORWARDED');
                else if(getenv('REMOTE_ADDR'))
                    $ipaddress = getenv('REMOTE_ADDR');
                else
                    $ipaddress = 'UNKNOWN';

                if (in_array($ipaddress, $pool)) {
                    return true;
                } else {
                    return false;
                }
            }

            public function checkTime(){
                
                $_SESSION['LastCall'] = time();
                $limit = time() - $this->lastCall;
                return $limit < 3;
            }
        // ----------
    }
?>