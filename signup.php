<?php
// Add these headers at the top to allow Flutter Web connections
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

header("Content-Type: application/json");

include 'db.php';
// ... rest of your code remains exactly the same

header("Content-Type: application/json");

include 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$username = trim($data["username"]);
$email = trim($data["email"]);
$password = trim($data["password"]);

if(empty($username) || empty($email) || empty($password))
{
    echo json_encode([
        "success"=>false,
        "message"=>"All fields are required"
    ]);
    exit();
}

$check = $conn->prepare("SELECT id FROM users WHERE email=?");
$check->bind_param("s",$email);
$check->execute();
$result = $check->get_result();

if($result->num_rows>0)
{
    echo json_encode([
        "success"=>false,
        "message"=>"Email already exists"
    ]);
    exit();
}

$hashedPassword = password_hash($password,PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO users(username,email,password) VALUES(?,?,?)");
$stmt->bind_param("sss",$username,$email,$hashedPassword);

if($stmt->execute())
{
    echo json_encode([
        "success"=>true,
        "message"=>"Registration Successful"
    ]);
}
else
{
    echo json_encode([
        "success"=>false,
        "message"=>"Registration Failed"
    ]);
}

$stmt->close();
$conn->close();

?>