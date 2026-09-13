<?php
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed']);
    exit();
}

$token = getBearerToken();
if ($token) {
    try {
        $stmt = $pdo->prepare("UPDATE users SET remember_token = NULL WHERE remember_token = ?");
        $stmt->execute([$token]);
    } catch (Exception $e) {
        // Silently ignore if column missing
    }
}

echo json_encode(['message' => 'Logged out successfully']);
?>
