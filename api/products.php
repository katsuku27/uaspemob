<?php
require_once 'config.php';

switch($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        $stmt = $pdo->query("SELECT * FROM products");
        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success' => true, 'products' => $products]);
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['name']) || !isset($data['price'])) {
            echo json_encode(['success' => false, 'message' => 'Name and price are required']);
            exit;
        }
        
        try {
            $stmt = $pdo->prepare("INSERT INTO products (name, price) VALUES (?, ?)");
            $stmt->execute([$data['name'], $data['price']]);
            echo json_encode(['success' => true, 'message' => 'Product added successfully']);
        } catch (PDOException $e) {
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        }
        break;
}