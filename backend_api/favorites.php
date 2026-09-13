<?php
require_once 'db.php';
require_once 'menu_items.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

// GET /api/favorites
if ($method === 'GET') {
    $stmt = $pdo->prepare("SELECT id, menu_item_id FROM favorites WHERE user_id = ? ORDER BY id DESC");
    $stmt->execute([$userId]);
    $rows = $stmt->fetchAll();

    $items = [];
    foreach ($rows as $row) {
        $fId = (int)$row['id'];
        $mId = (int)$row['menu_item_id'];
        $menuStmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
        $menuStmt->execute([$mId]);
        $menuItemData = $menuStmt->fetch();
        if ($menuItemData) {
            $menuItem = formatMenuItem($pdo, $menuItemData);
            $items[] = [
                'id' => $fId,
                'menu_item_id' => $mId,
                'product_id' => $mId,
                'menu_item' => $menuItem,
                'product' => $menuItem
            ];
        }
    }
    echo json_encode($items);
    exit();
}

// POST /api/favorites
if ($method === 'POST') {
    $input = getJsonInput();
    $menuItemId = (int)($input['menu_item_id'] ?? $input['product_id'] ?? 0);

    if ($menuItemId <= 0) {
        http_response_code(422);
        echo json_encode(['message' => 'Invalid food menu item ID']);
        exit();
    }

    $stmt = $pdo->prepare("SELECT id FROM favorites WHERE user_id = ? AND menu_item_id = ?");
    $stmt->execute([$userId, $menuItemId]);
    $existing = $stmt->fetch();

    if ($existing) {
        $fId = (int)$existing['id'];
    } else {
        $insert = $pdo->prepare("INSERT INTO favorites (user_id, menu_item_id) VALUES (?, ?)");
        $insert->execute([$userId, $menuItemId]);
        $fId = (int)$pdo->lastInsertId();
    }

    $menuStmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
    $menuStmt->execute([$menuItemId]);
    $menuItemData = $menuStmt->fetch();
    $menuItem = $menuItemData ? formatMenuItem($pdo, $menuItemData) : null;

    echo json_encode([
        'id' => $fId,
        'menu_item_id' => $menuItemId,
        'product_id' => $menuItemId,
        'menu_item' => $menuItem,
        'product' => $menuItem
    ]);
    exit();
}

// DELETE /api/favorites/{menuItemId}
if ($method === 'DELETE') {
    $targetId = (int)($_GET['menu_item_id'] ?? $_GET['product_id'] ?? $_GET['id'] ?? 0);

    if ($targetId > 0) {
        $stmt = $pdo->prepare("DELETE FROM favorites WHERE user_id = ? AND (id = ? OR menu_item_id = ?)");
        $stmt->execute([$userId, $targetId, $targetId]);
    }

    echo json_encode(['message' => 'Removed from favorites']);
    exit();
}
?>
