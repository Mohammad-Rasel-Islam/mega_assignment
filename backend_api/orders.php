<?php
require_once 'db.php';
require_once 'menu_items.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

// GET /api/orders
if ($method === 'GET') {
    if (isset($_GET['id'])) {
        $orderId = (int)$_GET['id'];
        $stmt = $pdo->prepare("SELECT * FROM orders WHERE id = ? AND user_id = ?");
        $stmt->execute([$orderId, $userId]);
        $order = $stmt->fetch();
        if (!$order) {
            http_response_code(404);
            echo json_encode(['message' => 'Order not found']);
            exit();
        }
        echo json_encode(formatOrder($pdo, $order));
        exit();
    }

    $stmt = $pdo->prepare("SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC");
    $stmt->execute([$userId]);
    $orders = $stmt->fetchAll();

    $result = [];
    foreach ($orders as $order) {
        $result[] = formatOrder($pdo, $order);
    }
    echo json_encode($result);
    exit();
}

// POST /api/orders
if ($method === 'POST') {
    $input = getJsonInput();
    $addressId = (int)($input['address_id'] ?? 0);

    // Fetch cart items
    $cartStmt = $pdo->prepare("
        SELECT c.*, m.name, m.price 
        FROM cart_items c 
        JOIN menu_items m ON c.menu_item_id = m.id 
        WHERE c.user_id = ?
    ");
    $cartStmt->execute([$userId]);
    $cartItems = $cartStmt->fetchAll();

    if (empty($cartItems)) {
        http_response_code(422);
        echo json_encode(['message' => 'Your cart is empty.']);
        exit();
    }

    $subtotal = 0.0;
    foreach ($cartItems as $ci) {
        $subtotal += ((float)$ci['price'] * (int)$ci['quantity']);
    }
    $deliveryFee = 0.0;
    $total = $subtotal + $deliveryFee;

    // Create Order
    $stmt = $pdo->prepare("INSERT INTO orders (user_id, address_id, status, subtotal, delivery_fee, total) VALUES (?, ?, 'pending', ?, ?, ?)");
    $stmt->execute([$userId, $addressId, $subtotal, $deliveryFee, $total]);
    $orderId = (int)$pdo->lastInsertId();

    // Insert Order Items
    $itemStmt = $pdo->prepare("INSERT INTO order_items (order_id, menu_item_id, quantity, price, color, size) VALUES (?, ?, ?, ?, ?, ?)");
    foreach ($cartItems as $ci) {
        $itemStmt->execute([$orderId, $ci['menu_item_id'], $ci['quantity'], $ci['price'], $ci['color'], $ci['size']]);
    }

    // Clear user's cart
    $clearCart = $pdo->prepare("DELETE FROM cart_items WHERE user_id = ?");
    $clearCart->execute([$userId]);

    echo json_encode(['id' => $orderId, 'message' => 'Order placed successfully']);
    exit();
}

function formatOrder($pdo, $order) {
    $orderId = (int)$order['id'];
    
    // Address
    $addrStmt = $pdo->prepare("SELECT * FROM addresses WHERE id = ?");
    $addrStmt->execute([(int)$order['address_id']]);
    $address = $addrStmt->fetch();
    if ($address) {
        $address['id'] = (int)$address['id'];
        $address['is_default'] = (bool)$address['is_default'];
    }

    // Items
    $itemStmt = $pdo->prepare("
        SELECT oi.*, m.name 
        FROM order_items oi 
        JOIN menu_items m ON oi.menu_item_id = m.id 
        WHERE oi.order_id = ?
    ");
    $itemStmt->execute([$orderId]);
    $rawItems = $itemStmt->fetchAll();

    $items = [];
    foreach ($rawItems as $ri) {
        $mId = (int)$ri['menu_item_id'];
        $menuStmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
        $menuStmt->execute([$mId]);
        $menuItemData = $menuStmt->fetch();
        $menuItem = $menuItemData ? formatMenuItem($pdo, $menuItemData) : null;

        $items[] = [
            'id' => (int)$ri['id'],
            'menu_item_id' => $mId,
            'product_id' => $mId,
            'quantity' => (int)$ri['quantity'],
            'price' => (float)$ri['price'],
            'color' => $ri['color'],
            'size' => $ri['size'],
            'menu_item' => $menuItem,
            'product' => $menuItem
        ];
    }

    return [
        'id' => $orderId,
        'status' => $order['status'],
        'subtotal' => (float)$order['subtotal'],
        'delivery_fee' => (float)$order['delivery_fee'],
        'total' => (float)$order['total'],
        'created_at' => $order['created_at'],
        'address' => $address,
        'items' => $items,
    ];
}
?>
