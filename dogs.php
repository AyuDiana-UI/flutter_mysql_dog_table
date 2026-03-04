<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// WAJIB: Menangani Pre-flight request dari Browser Edge
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $result = $conn->query("SELECT * FROM dogs");
        $dogs = array();
        while ($row = $result->fetch_assoc()) {
            // Memastikan age dikirim sebagai int agar tidak error di Flutter
            $row['id'] = (int) $row['id'];
            $row['age'] = (int) $row['age'];
            $dogs[] = $row;
        }
        echo json_encode($dogs);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        if (isset($data['name']) && isset($data['age'])) {
            $name = $data['name'];
            $age = (int) $data['age'];
            $stmt = $conn->prepare("INSERT INTO dogs (name, age) VALUES (?, ?)");
            $stmt->bind_param("si", $name, $age);
            if ($stmt->execute()) {
                echo json_encode(["message" => "Success"]);
            }
            $stmt->close();
        }
        break;

    case 'DELETE':
        if (isset($_GET['id'])) {
            $id = (int) $_GET['id'];
            $stmt = $conn->prepare("DELETE FROM dogs WHERE id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            echo json_encode(["message" => "Deleted"]);
            $stmt->close();
        }
        break;
}
$conn->close();
?>