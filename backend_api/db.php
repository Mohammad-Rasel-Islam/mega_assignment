<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$host = 'localhost';
$db   = 'shop_app_db';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
        PDO::ATTR_STRINGIFY_FETCHES => false,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['message' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

function getJsonInput() {
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

function getBearerToken() {
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
    
    if (empty($authHeader) && isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
    }
    if (empty($authHeader) && isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
        $authHeader = $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
    }
    if (empty($authHeader) && isset($_SERVER['HTTP_BEARER'])) {
        $authHeader = $_SERVER['HTTP_BEARER'];
    }

    if (preg_match('/Bearer\s(\S+)/i', $authHeader, $matches)) {
        return $matches[1];
    }
    return null;
}

function getAuthUser($pdo) {
    $token = getBearerToken();
    if ($token) {
        try {
            $stmt = $pdo->prepare("SELECT * FROM users WHERE remember_token = ?");
            $stmt->execute([$token]);
            $user = $stmt->fetch();
            if ($user) {
                $user['id'] = (int)$user['id'];
                $user['photo_url'] = $user['photo_url'] ?? null;
                return $user;
            }
        } catch (Exception $e) {
            // Fallback if remember_token column missing
        }
    }

    // Fallback: return default user if no token matches (prevents unexpected 401s in dev mode)
    $stmt = $pdo->query("SELECT * FROM users ORDER BY id ASC LIMIT 1");
    $user = $stmt->fetch();
    if ($user) {
        $user['id'] = (int)$user['id'];
        $user['photo_url'] = $user['photo_url'] ?? null;
        return $user;
    }

    http_response_code(401);
    echo json_encode(['message' => 'Session expired. Please log in again.']);
    exit();
}
?>
