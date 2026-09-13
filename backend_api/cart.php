<?php
require_once 'db.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

// GET /api/cart
if ($method === 'GET') {
    $stmt = $pdo->prepare("
        SELECT c.id, c.product_id, c.color, c.size, c.quantity, p.name, p.price
        FROM cart_items c
        JOIN products p ON c.product_id = p.id
        WHERE c.user_id = ?
    ");
    $stmt->execute([$userId]);
    $items = $stmt->fetchAll();

    foreach ($items as &$item) {
        $itemId = (int)$item['id'];
        $prodId = (int)$item['product_id'];

        $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ? LIMIT 1");
        $imgStmt->execute([$prodId]);
        $img = $imgStmt->fetchColumn() ?: '';

        $item['id'] = $itemId;
        $item['product_id'] = $prodId;
        $item['quantity'] = (int)$item['quantity'];
        $item['price'] = (float)$item['price'];
        $item['product'] = [
            'id' => $prodId,
            'name' => $item['name'],
            'price' => (float)$item['price'],
            'product_images' => [['image_url' => $img]]
        ];
    }
    echo json_encode($items);
    exit();
}

// POST /api/cart
if ($method === 'POST') {
    $input = getJsonInput();
    $productId = (int)($input['product_id'] ?? 0);
    $color = $input['color'] ?? '';
    $size = $input['size'] ?? '';
    $quantity = (int)($input['quantity'] ?? 1);

    $stmt = $pdo->prepare("INSERT INTO cart_items (user_id, product_id, color, size, quantity) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$userId, $productId, $color, $size, $quantity]);
    $cartId = (int)$pdo->lastInsertId();

    // Fetch inserted item with product
    $prodStmt = $pdo->prepare("SELECT name, price FROM products WHERE id = ?");
    $prodStmt->execute([$productId]);
    $product = $prodStmt->fetch();

    $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ? LIMIT 1");
    $imgStmt->execute([$productId]);
    $img = $imgStmt->fetchColumn() ?: '';

    echo json_encode([
        'id' => $cartId,
        'product_id' => $productId,
        'color' => $color,
        'size' => $size,
        'quantity' => $quantity,
        'price' => (float)($product['price'] ?? 0),
        'product' => [
            'id' => $productId,
            'name' => $product['name'] ?? '',
            'price' => (float)($product['price'] ?? 0),
            'product_images' => [['image_url' => $img]]
        ]
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
