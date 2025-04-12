<?php
require 'login.php';
$schema = 'evoting';

/******************************************
 *          Main dispatching              *
 ******************************************/
if (array_key_exists('api', $_POST)) {
	if ($_POST['api'] == 'get-surveys') {
		$dbconn = pg_connect("host=".$host." dbname=".$dbname." user=".$user." password=".$password) or die ('Impossible to connect to the database: '.pg_last_error());
		$res = pg_query_params("select surveys.id, surveys.title, fullname from {$schema}.surveys inner join {$schema}.users on surveys.owner=users.id where owner in (select id from {$schema}.users where case when (select admin from {$schema}.users where token=$1) then true else token=$1 end)", array($_COOKIE['token'])) or die('Request failed: '.pg_last_error());
		$rows = pg_fetch_all($res);
		if (!$rows) $rows = array();
		header("Content-Type: application/json");
		echo json_encode($rows);
	}
}

?>
