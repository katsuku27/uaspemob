<?php
require_once 'config.php';

switch($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        try {
            header('Content-Type: application/json');
            
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['total_amount']) || !isset($data['items'])) {
                throw new Exception('Invalid data format');
            }

            $pdo->beginTransaction();

            $stmt = $pdo->prepare("INSERT INTO transactions (total_amount, created_at) VALUES (?, NOW())");
            $stmt->execute([$data['total_amount']]);
            $transactionId = $pdo->lastInsertId();

            $stmt = $pdo->prepare("INSERT INTO transaction_items (transaction_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
            foreach ($data['items'] as $item) {
                $stmt->execute([
                    $transactionId,
                    $item['product_id'], 
                    $item['quantity'],
                    $item['price']
                ]);
            }

            $pdo->commit();
            echo json_encode([
                'success' => true,
                'message' => 'Transaction completed successfully',
                'transaction_id' => $transactionId
            ]);

        } catch (Exception $e) {
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
            error_log("Transaction error: " . $e->getMessage());
            echo json_encode([
                'success' => false,
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'GET':
        header('Content-Type: application/json');
        try {
            $stmt = $pdo->query("SELECT * FROM transactions ORDER BY created_at DESC");
            $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['success' => true, 'transactions' => $transactions]);
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        }
        break;
}