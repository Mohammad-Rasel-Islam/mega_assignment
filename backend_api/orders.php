<?php
require_once 'db.php';

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
        SELECT c.*, p.name, p.price 
        FROM cart_items c 
        JOIN products p ON c.product_id = p.id 
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
    $itemStmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, quantity, price, color, size) VALUES (?, ?, ?, ?, ?, ?)");
    foreach ($cartItems as $ci) {
        $itemStmt->execute([$orderId, $ci['product_id'], $ci['quantity'], $ci['price'], $ci['color'], $ci['size']]);
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
        SELECT oi.*, p.name 
        FROM order_items oi 
        JOIN products p ON oi.product_id = p.id 
        WHERE oi.order_id = ?
    ");
    $itemStmt->execute([$orderId]);
    $rawItems = $itemStmt->fetchAll();

    $items = [];
    foreach ($rawItems as $ri) {
        $pid = (int)$ri['product_id'];
        $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ? LIMIT 1");
        $imgStmt->execute([$pid]);
        $img = $imgStmt->fetchColumn() ?: '';

        $items[] = [
            'id' => (int)$ri['id'],
            'product_id' => $pid,
            'quantity' => (int)$ri['quantity'],
            'price' => (float)$ri['price'],
            'color' => $ri['color'],
            'size' => $ri['size'],
            'product' => [
                'id' => $pid,
                'name' => $ri['name'],
                'price' => (float)$ri['price'],
                'product_images' => [['image_url' => $img]]
            ]
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
