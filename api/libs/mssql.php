<?php

    use \PDO;

    class mssqlDb extends \PDO {
        
        private $host = '',
                $port = '',
                $user = '',
                $password = '',
                $database = '',
                $schema = '';

        protected $result,$q,$stmt,$params = array(),$dbLink = NULL,$dbLink2 = NULL,$records = array();

        public function __construct(){
            
            try {
                if($this->dbLink == NULL ){
                    $this->dbLink = new PDO(
                        'sqlsrv:server='.$this->host.','.$this->port.';Database='.$this->database,$this->user,$this->password
                    );
                }
            }
            catch(Exception $e) {
                echo 'DB Connection error: '.$e->getCode().', '.$e->getMessage();
            }
        }

        public function execProc($call,$params=NULL){
            
            $cl = '';
            if(is_array($params)){
                foreach($params as $param){
                    if ($param[1] == NULL || $param[1] == 'null') {
                        $cl .= 'NULL,';
                    }else{
                        switch ($param[0]) {
                            case 'varchar':
                                $cl .= "'".str_replace("'","''",$param[1])."',";
                                break;
                            case 'varbinary':
                                $cl .= "'".$param[1]."',";
                                break;
                            default:
                                $cl .= $param[1].',';
                                break;
                        }
                    }
                }
            }
            $cl = substr($cl,0,strlen($cl)-1);
            try{
                $this->stmt = $this->dbLink->prepare('SET NOCOUNT ON EXEC '.$this->schema.'.'.$call.' '.$cl);
                $this->stmt->execute();
            }catch(Exception $e){
                echo 'Procedure execution error: '.$e->getMessage();
            }
        }

        public function getData(){

            try{
                return  $this->records = $this->stmt->fetch(PDO::FETCH_ASSOC);
            }  catch (Exception $e){
                echo 'Fetching data error: '.$e->getMessage();
            }
        }

        public function numRows($query=''){

            if(isset($this->stmt))return $this->stmt->rowCount();
            else return 0;
        }

        public function custom_query($sql){

            $this->lastCall = 'query';
            $this->stmt = $this->dbLink->query($sql);
        }
    }
?>