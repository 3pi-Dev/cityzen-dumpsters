<?php

    if(isset($_REQUEST) && $_REQUEST[act]){

        include_once('libs/handler.php');
        $myApiObj = new jsonApi();

        $whiteList = array(login,logout,getLogs,insertLog);
        
        header("Content-type:application/json");
        if (in_array($_REQUEST[act], $whiteList)) {
            $myApiObj->manageData();
        } else {
            if ($myApiObj->checkUser()) {
                $myApiObj->manageData();
            }else{
                http_response_code(401);
                echo json_encode(array(error=>'Error, User not authorized!'));
                session_unset();
                session_destroy();
                die();
            }
        }
    }else {
        header("Content-type:application/json");
        http_response_code(400);
        echo json_encode(array(error=>'Error, Bad request!'));
    }