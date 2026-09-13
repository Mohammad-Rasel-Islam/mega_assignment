<?php
require_once 'db.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

// GET /api/addresses
if ($method === 'GET') {
    $stmt = $pdo->prepare("SELECT * FROM addresses WHERE user_id = ?");
    $stmt->execute([$userId]);
    $addresses = $stmt->fetchAll();

    foreach ($addresses as &$addr) {
        $addr['id'] = (int)$addr['id'];
        $addr['is_default'] = (bool)$addr['is_default'];
    }
    echo json_encode($addresses);
    exit();
}

// POST /api/addresses
if ($method === 'POST') {
    $input = getJsonInput();
    $label = $input['label'] ?? 'Home';
    $fullAddress = $input['full_address'] ?? '';
    $lat = $input['lat'] ?? null;
    $lng = $input['lng'] ?? null;
    $isDefault = isset($input['is_default']) && $input['is_default'] ? 1 : 0;

    $stmt = $pdo->prepare("INSERT INTO addresses (user_id, label, full_address, lat, lng, is_default) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->execute([$userId, $label, $fullAddress, $lat, $lng, $isDefault]);
    $addrId = (int)$pdo->lastInsertId();

    echo json_encode([
        'id' => $addrId,
        'label' => $label,
        'full_address' => $fullAddress,
        'lat' => $lat,
        'lng' => $lng,
        'is_default' => (bool)$isDefault
    ]);
    exit();
}
?>
