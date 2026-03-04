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

// Menutup skrip jika koneksi database gagal
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Metode operasi HTTP dari API
// Disini, digunakan GET, POST, dan DELETE
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // query() menjalankan sebuah queri / command SQL di database.
        // Untuk queri SELECT, sebuah variabel akan menampung data tiap barisnya
        $result = $conn->query("SELECT * FROM dogs");
        
        // Sebuah array kosong yang menampung data-data Dog yang telah diproses.
        $dogs = array();
        
        // Mengkonversi tipe id dan age dari string menjadi int
        // Lalu memasukkan data-datanya ke dalam array dogs
        // Supaya tidak error di Flutter yang bersifat strict
        while ($row = $result->fetch_assoc()) {
            $row['id'] = (int) $row['id'];
            $row['age'] = (int) $row['age'];
            $dogs[] = $row;
        }
        // Mengoutput data-data Dogs kepada API
        echo json_encode($dogs);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        // Memeriksa apakah terdapat ID untuk ditarget
        if (isset($data['name']) && isset($data['age'])) {
            $name = $data['name'];
            $age = (int) $data['age'];
            // Mempersiapkan sebuah statement (stmt) untuk dijalankan
            $stmt = $conn->prepare("INSERT INTO dogs (name, age) VALUES (?, ?)");
            // Menyisipkan parameter ke dalam statement
            $stmt->bind_param("si", $name, $age);
            // Menjalankan statementnya.
            if ($stmt->execute()) {
                // Melaporkan pesan akhir
                echo json_encode(["message" => "Success"]);
            }
            $stmt->close();
        }
        break;

    case 'DELETE':
        // Memeriksa apakah terdapat ID untuk ditarget
        if (isset($_GET['id'])) {
            // Dikonversi dari string menjadi int
            $id = (int) $_GET['id'];

            // Mempersiapkan sebuah statement (stmt) untuk dijalankan
            $stmt = $conn->prepare("DELETE FROM dogs WHERE id = ?");
            // Menyisipkan parameter ke dalam statement
            $stmt->bind_param("i", $id);
            // Menjalankan statementnya.
            $stmt->execute();
            // Melaporkan pesan akhir
            echo json_encode(["message" => "Deleted"]);
            $stmt->close();
        }
        break;
}
// Menutup koneksi database
$conn->close();

?>
