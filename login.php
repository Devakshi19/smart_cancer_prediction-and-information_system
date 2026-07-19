<?php
// Add these headers to allow requests from any origin (Flutter Web)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

header("Content-Type: application/json");

include 'db.php';
// ... rest of your code remains exactly the same

header("Content-Type: application/json");

include 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$email = trim($data["email"]);
$password = trim($data["password"]);

if(empty($email) || empty($password))
{
    echo json_encode([
        "success"=>false,
        "message"=>"Email and Password Required"
    ]);
    exit();
}

$stmt = $conn->prepare("SELECT * FROM users WHERE email=?");
$stmt->bind_param("s",$email);
$stmt->execute();

$result = $stmt->get_result();

if($result->num_rows==1)
{
    $user = $result->fetch_assoc();

    if(password_verify($password,$user["password"]))
    {
        echo json_encode([
            "success"=>true,
            "message"=>"Login Successful",
            "user"=>[
                "id"=>$user["id"],
                "username"=>$user["username"],
                "email"=>$user["email"]
            ]
        ]);
    }
    else
    {
        echo json_encode([
            "success"=>false,
            "message"=>"Incorrect Password"
        ]);
    }
}
else
{
    echo json_encode([
        "success"=>false,
        "message"=>"Email Not Found"
    ]);
}

$stmt->close();
$conn->close();

?>