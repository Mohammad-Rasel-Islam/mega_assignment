<?php
require_once 'db.php';

// Single product by ID
if (isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    $stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
    $stmt->execute([$id]);
    $product = $stmt->fetch();
    if (!$product) {
        http_response_code(404);
        echo json_encode(['message' => 'Product not found']);
        exit();
    }
    
    // Fetch product images
    $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ?");
    $imgStmt->execute([$id]);
    $images = $imgStmt->fetchAll(PDO::FETCH_COLUMN);

    $product['id'] = (int)$product['id'];
    $product['category_id'] = (int)$product['category_id'];
    $product['price'] = (float)$product['price'];
    $product['rating'] = (float)$product['rating'];
    $product['is_popular'] = (bool)$product['is_popular'];
    $product['colors'] = json_decode($product['colors'] ?? '[]', true);
    $product['sizes'] = json_decode($product['sizes'] ?? '[]', true);
    $product['product_images'] = array_map(fn($url) => ['image_url' => $url], $images);

    echo json_encode($product);
    exit();
}

// List products with optional search / category filter
$categoryId = $_GET['category_id'] ?? null;
$search = $_GET['search'] ?? null;

$sql = "SELECT p.* FROM products p WHERE 1=1";
$params = [];

if ($categoryId && $categoryId !== 'all') {
    $sql .= " AND p.category_id = ?";
    $params[] = (int)$categoryId;
}

if ($search) {
    $sql .= " AND (p.name LIKE ? OR p.description LIKE ?)";
    $params[] = "%$search%";
    $params[] = "%$search%";
}

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$products = $stmt->fetchAll();

foreach ($products as &$prod) {
    $prodId = (int)$prod['id'];
    $imgStmt = $pdo->prepare("SELECT image_url FROM product_images WHERE product_id = ?");
    $imgStmt->execute([$prodId]);
    $images = $imgStmt->fetchAll(PDO::FETCH_COLUMN);

    $prod['id'] = $prodId;
    $prod['category_id'] = (int)$prod['category_id'];
    $prod['price'] = (float)$prod['price'];
    $prod['rating'] = (float)$prod['rating'];
    $prod['is_popular'] = (bool)$prod['is_popular'];
    $prod['colors'] = json_decode($prod['colors'] ?? '[]', true);
    $prod['sizes'] = json_decode($prod['sizes'] ?? '[]', true);
    $prod['product_images'] = array_map(fn($url) => ['image_url' => $url], $images);
}

echo json_encode($products);
?>
