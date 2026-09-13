<?php
require_once 'db.php';

$user = getAuthUser($pdo);
$userId = $user['id'];
$method = $_SERVER['REQUEST_METHOD'];

function getFullProductForWishlist($pdo, $productId) {
    $stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
    $stmt->execute([$productId]);
    $product = $stmt->fetch();
    if (!$product) return null;

    $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ?");
    $imgStmt->execute([$productId]);
    $images = $imgStmt->fetchAll(PDO::FETCH_COLUMN);

    return [
        'id' => (int)$product['id'],
        'name' => $product['name'],
        'description' => $product['description'] ?? '',
        'price' => (float)$product['price'],
        'category_id' => (int)$product['category_id'],
        'rating' => (float)$product['rating'],
        'is_popular' => (bool)$product['is_popular'],
        'colors' => json_decode($product['colors'] ?? '[]', true) ?: [],
        'sizes' => json_decode($product['sizes'] ?? '[]', true) ?: [],
        'product_images' => array_map(fn($url) => ['image_url' => $url], $images)
    ];
}

// GET /api/wishlist
if ($method === 'GET') {
    $stmt = $pdo->prepare("SELECT id, product_id FROM wishlists WHERE user_id = ? ORDER BY id DESC");
    $stmt->execute([$userId]);
    $rows = $stmt->fetchAll();

    $items = [];
    foreach ($rows as $row) {
        $wId = (int)$row['id'];
        $pId = (int)$row['product_id'];
        $product = getFullProductForWishlist($pdo, $pId);
        if ($product) {
            $items[] = [
                'id' => $wId,
                'product_id' => $pId,
                'product' => $product
            ];
        }
    }
    echo json_encode($items);
    exit();
}

// POST /api/wishlist
if ($method === 'POST') {
    $input = getJsonInput();
    $productId = (int)($input['product_id'] ?? 0);

    if ($productId <= 0) {
        http_response_code(422);
        echo json_encode(['message' => 'Invalid product ID']);
        exit();
    }

    $stmt = $pdo->prepare("SELECT id FROM wishlists WHERE user_id = ? AND product_id = ?");
    $stmt->execute([$userId, $productId]);
    $existing = $stmt->fetch();

    if ($existing) {
        $wId = (int)$existing['id'];
    } else {
        $insert = $pdo->prepare("INSERT INTO wishlists (user_id, product_id) VALUES (?, ?)");
        $insert->execute([$userId, $productId]);
        $wId = (int)$pdo->lastInsertId();
    }

    $product = getFullProductForWishlist($pdo, $productId);

    echo json_encode([
        'id' => $wId,
        'product_id' => $productId,
        'product' => $product
    ]);
    exit();
}

// DELETE /api/wishlist/{productId}
if ($method === 'DELETE') {
    $targetId = (int)($_GET['product_id'] ?? $_GET['id'] ?? 0);

    if ($targetId > 0) {
        $stmt = $pdo->prepare("DELETE FROM wishlists WHERE user_id = ? AND (id = ? OR product_id = ?)");
        $stmt->execute([$userId, $targetId, $targetId]);
    }

    echo json_encode(['message' => 'Removed from wishlist']);
    exit();
}
?>
