<?php
require_once 'config.php';

$today = date('Y-m-d');
$response = [];

try {
    $stmt = $pdo->prepare("SELECT COUNT(*) as transaction_count, COALESCE(SUM(total_amount), 0) as total_sales 
                            FROM transactions 
                            WHERE DATE(created_at) = ?");
    $stmt->execute([$today]);
    $todayStats = $stmt->fetch(PDO::FETCH_ASSOC);

    $todayStats['transaction_count'] = (int)$todayStats['transaction_count'];
    $todayStats['total_sales'] = (float)$todayStats['total_sales'];

    error_log("Today's stats: " . json_encode($todayStats));

    $stmt = $pdo->prepare("SELECT DATE(created_at) as date, 
                            COALESCE(SUM(total_amount), 0) as total_sales 
                            FROM transactions 
                            WHERE created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
                            GROUP BY DATE(created_at)
                            ORDER BY date");
    $stmt->execute();
    $weeklySales = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'today_stats' => $todayStats,
        'weekly_sales' => $weeklySales
    ]);
} catch (Exception $e) {
    error_log("Error in dashboard.php: " . $e->getMessage());
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}