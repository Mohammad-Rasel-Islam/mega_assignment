<?php
require_once 'db.php';

function formatMenuItem($pdo, $item) {
    $mId = (int)$item['id'];
    
    // Fetch ingredients for this menu item
    $ingStmt = $pdo->prepare("SELECT * FROM menu_item_ingredients WHERE menu_item_id = ? ORDER BY id ASC");
    $ingStmt->execute([$mId]);
    $rawIngs = $ingStmt->fetchAll();

    $ingredients = [];
    foreach ($rawIngs as $ing) {
        $ingredients[] = [
            'id' => (int)$ing['id'],
            'menu_item_id' => (int)$ing['menu_item_id'],
            'ingredient_name' => $ing['ingredient_name'],
            'image_url' => $ing['image_url'],
            'quantity_gm' => (int)$ing['quantity_gm'],
            'base_servings' => (int)$ing['base_servings'],
        ];
    }

    return [
        'id' => $mId,
        'category_id' => (int)$item['category_id'],
        'name' => $item['name'],
        'description' => $item['description'] ?? '',
        'price' => (float)$item['price'],
        'image_url' => $item['image_url'],
        'calories' => (int)$item['calories'],
        'prep_time_minutes' => (int)$item['prep_time_minutes'],
        'rating' => (float)$item['rating'],
        'review_count' => (int)$item['review_count'],
        'is_popular' => (bool)$item['is_popular'],
        'ingredients' => $ingredients,
        // Compatibility field for widgets using primary image or product_images array
        'product_images' => [['image_url' => $item['image_url']]]
    ];
}

// GET single item by ID
if (isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    $stmt = $pdo->prepare("SELECT * FROM menu_items WHERE id = ?");
    $stmt->execute([$id]);
    $item = $stmt->fetch();
    if (!$item) {
        http_response_code(404);
        echo json_encode(['message' => 'Menu item not found']);
        exit();
    }
    echo json_encode(formatMenuItem($pdo, $item));
    exit();
}

// GET list with filters (category_id, search, is_popular)
$categoryId = $_GET['category_id'] ?? null;
$search = $_GET['search'] ?? null;
$isPopular = $_GET['is_popular'] ?? null;

$sql = "SELECT * FROM menu_items WHERE 1=1";
$params = [];

if ($categoryId && $categoryId !== 'all') {
    $sql .= " AND category_id = ?";
    $params[] = (int)$categoryId;
}

if ($search) {
    $sql .= " AND (name LIKE ? OR description LIKE ?)";
    $params[] = "%$search%";
    $params[] = "%$search%";
}

if ($isPopular !== null) {
    $sql .= " AND is_popular = ?";
    $params[] = (int)$isPopular;
}

$sql .= " ORDER BY id ASC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$items = $stmt->fetchAll();

$result = [];
foreach ($items as $item) {
    $result[] = formatMenuItem($pdo, $item);
}

echo json_encode($result);
?>
