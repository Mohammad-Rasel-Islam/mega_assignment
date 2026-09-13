<?php
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed']);
    exit();
}

$input = getJsonInput();
$name = trim($input['name'] ?? '');
$email = trim($input['email'] ?? '');
$password = $input['password'] ?? '';

if (empty($name) || empty($email) || empty($password)) {
    http_response_code(422);
    echo json_encode(['message' => 'Please provide name, email, and password.']);
    exit();
}

// Check email uniqueness
$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    http_response_code(422);
    echo json_encode(['message' => 'The email address is already registered.']);
    exit();
}

// Generate token & hash password
$token = bin2hex(random_bytes(32));
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

try {
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, remember_token) VALUES (?, ?, ?, ?)");
    $stmt->execute([$name, $email, $hashedPassword, $token]);
} catch (Exception $e) {
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->execute([$name, $email, $hashedPassword]);
}

$userId = (int)$pdo->lastInsertId();

echo json_encode([
    'token' => $token,
    'user' => [
        'id' => $userId,
        'name' => $name,
        'email' => $email,
        'photo_url' => null,
    ]
]);
?>
