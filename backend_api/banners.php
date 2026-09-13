<?php
require_once 'db.php';

$stmt = $pdo->query("SELECT * FROM banners ORDER BY id ASC");
$banners = $stmt->fetchAll();

foreach ($banners as &$b) {
    $b['id'] = (int)$b['id'];
}

echo json_encode($banners);
?>
