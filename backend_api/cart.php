<?php
require_once 'db.php';
require_once 'menu_items.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

// GET /api/cart
if ($method === 'GET') {
    $stmt = $pdo->prepare("
        SELECT c.id, c.menu_item_id, c.color, c.size, c.quantity, m.name, m.price
        FROM cart_items c
        JOIN menu_items m ON c.menu_item_id = m.id
        WHERE c.user_id = ?
        ORDER BY c.id DESC
    ");
    $stmt->execute([$userId]);
    $items = $stmt->fetchAll();

    foreach ($items as &$item) {
        $itemId = (int)$item['id'];
        $mId = (int)$item['menu_item_id'];

        $menuStmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
        $menuStmt->execute([$mId]);
        $menuItemData = $menuStmt->fetch();
        $menuItem = $menuItemData ? formatMenuItem($pdo, $menuItemData) : null;

        $item['id'] = $itemId;
        $item['menu_item_id'] = $mId;
        $item['product_id'] = $mId;
        $item['quantity'] = (int)$item['quantity'];
        $item['price'] = (float)$item['price'];
        $item['menu_item'] = $menuItem;
        $item['product'] = $menuItem;
    }
    echo json_encode($items);
    exit();
}

// POST /api/cart
if ($method === 'POST') {
    $input = getJsonInput();
    $menuItemId = (int)($input['menu_item_id'] ?? $input['product_id'] ?? 0);
    $color = $input['color'] ?? '';
    $size = $input['size'] ?? '';
    $quantity = (int)($input['quantity'] ?? 1);

    if ($menuItemId <= 0) {
        http_response_code(422);
        echo json_encode(['message' => 'Invalid food menu item ID']);
        exit();
    }

    // Check if item already exists in cart for this user
    $checkStmt = $pdo->prepare("SELECT id, quantity FROM cart_items WHERE user_id = ? AND menu_item_id = ?");
    $checkStmt->execute([$userId, $menuItemId]);
    $existing = $checkStmt->fetch();

    if ($existing) {
        $newQty = (int)$existing['quantity'] + $quantity;
        $updateStmt = $pdo->prepare("UPDATE cart_items SET quantity = ? WHERE id = ?");
        $updateStmt->execute([$newQty, $existing['id']]);
        $cartId = (int)$existing['id'];
        $quantity = $newQty;
    } else {
        $stmt = $pdo->prepare("INSERT INTO cart_items (user_id, menu_item_id, color, size, quantity) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$userId, $menuItemId, $color, $size, $quantity]);
        $cartId = (int)$pdo->lastInsertId();
    }

    $menuStmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
    $menuStmt->execute([$menuItemId]);
    $menuItemData = $menuStmt->fetch();
    $menuItem = $menuItemData ? formatMenuItem($pdo, $menuItemData) : null;

    echo json_encode([
        'id' => $cartId,
        'menu_item_id' => $menuItemId,
        'product_id' => $menuItemId,
        'color' => $color,
        'size' => $size,
        'quantity' => $quantity,
        'price' => (float)($menuItemData['price'] ?? 0),
        'menu_item' => $menuItem,
        'product' => $menuItem
    ]);
    exit();
}

// PUT /api/cart/{id}
if ($method === 'PUT') {
    $id = (int)($_GET['id'] ?? 0);
    $input = getJsonInput();
    $quantity = (int)($input['quantity'] ?? 1);

    $stmt = $pdo->prepare("UPDATE cart_items SET quantity = ? WHERE id = ? AND user_id = ?");
    $stmt->execute([$quantity, $id, $userId]);
    echo json_encode(['message' => 'Cart updated']);
    exit();
}

// DELETE /api/cart/{id}
if ($method === 'DELETE') {
    $id = (int)($_GET['id'] ?? 0);
    $stmt = $pdo->prepare("DELETE FROM cart_items WHERE id = ? AND user_id = ?");
    $stmt->execute([$id, $userId]);
    echo json_encode(['message' => 'Item removed']);
    exit();
}
?>
