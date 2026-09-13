<?php
require_once 'db.php';

$stmt = $pdo->query("SELECT id, name, icon, image_url FROM categories");
$categories = $stmt->fetchAll();

foreach ($categories as &$cat) {
    $cat['id'] = (int)$cat['id'];
}

echo json_encode($categories);
?>
