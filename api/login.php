<?php
require_once 'config.php';

$data = json_decode(file_get_contents('php://input'), true);
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
$stmt->execute([$username, $password]);
$user = $stmt->fetch();

if ($user) {
    echo json_encode([
        'success' => true,
        'user' => [
            'id' => $user['id'],
            'username' => $user['username']
        ]
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Username atau Password Anda salah'
    ]);
}