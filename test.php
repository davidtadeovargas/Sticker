<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once('Response.php');
require_once('DB.php');
require_once('DBS.php');
require_once('consts.php');

header('Content-Type: application/json; charset=utf-8');

try {
    DB::open();

    $query = $_GET['query']; // Obtener el query de la base de datos desde el parámetro GET

    $result = DB::runQRY($query);

    if ($result !== false) {
        $results = array(); // Lista de resultados

        while ($row = mysqli_fetch_assoc($result)) {
            $results[] = $row;
        }

        // Cerrar el objeto de resultado
        mysqli_free_result($result);

        DB::close();

        // Devolver los resultados como respuesta
        echo json_encode($results);
    } else {
        throw new Exception('Error en la ejecución de la consulta.');
    }
} catch (Exception $e) {
    echo Response::ERRORResponse('exception', $e->getMessage());
}
?>
