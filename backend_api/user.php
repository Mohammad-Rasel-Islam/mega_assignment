<?php
require_once 'db.php';

$user = getAuthUser($pdo);

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    echo json_encode($user);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' || $_SERVER['REQUEST_METHOD'] === 'PUT') {
    $name = $_POST['name'] ?? getJsonInput()['name'] ?? $user['name'];
    
    // Handle optional file upload
    $photoUrl = $user['photo_url'];
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $ext = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
        $fileName = 'user_' . $user['id'] . '_' . time() . '.' . $ext;
        $targetDir = __DIR__ . '/uploads/';
        if (!file_exists($targetDir)) {
            mkdir($targetDir, 0777, true);
        }
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $targetDir . $fileName)) {
            $photoUrl = 'http://10.0.2.2/api/uploads/' . $fileName;
        }
    }

    $stmt = $pdo->prepare("UPDATE users SET name = ?, photo_url = ? WHERE id = ?");
    $stmt->execute([$name, $photoUrl, $user['id']]);

    $user['name'] = $name;
    $user['photo_url'] = $photoUrl;
    echo json_encode($user);
    exit();
}
?>
