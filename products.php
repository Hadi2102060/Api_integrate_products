<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$categories = ['Bags', 'Accessories', 'Eyewear', 'Electronics', 'Clothing', 'Shoes', 'Jewelry', 'Home Decor', 'Sports', 'Beauty'];
$productNames = ['Premium Leather Handbag', 'Elegant Wallet', 'Designer Sunglasses', 'Stylish Backpack', 'Smart Watch', 'Wireless Earbuds', 'Cotton T-Shirt', 'Running Shoes', 'Diamond Necklace', 'Table Lamp', 'Yoga Mat', 'Lipstick Set', 'Laptop Backpack', 'Sunglasses Case', 'Leather Belt', 'Hoodie', 'Sneakers', 'Gold Ring', 'Wall Clock', 'Protein Shaker'];
$descriptions = ['Premium quality', 'Stylish and durable', 'UV protection', 'Spacious and trendy', 'High-tech features', 'Crystal clear sound', 'Soft cotton fabric', 'Lightweight design', 'Elegant look', 'Eco-friendly material', 'Limited edition', 'Best seller'];

// 📸 শুধু এই লাইনটি পরিবর্তন করুন (আপনার ডোমেইন ও ফোল্ডার অনুযায়ী)
$baseImageUrl = "https://hadi.olivosoft.com/images/";

$products = [];

for ($i = 1; $i <= 100; $i++) {
    $category = $categories[array_rand($categories)];
    $name = $productNames[array_rand($productNames)] . ' ' . chr(64 + rand(1, 26)) . rand(100, 999);
    
    $discount = (rand(1, 10) <= 3) ? rand(5, 40) : 0;
    $originalPrice = rand(15, 250) + 0.99;
    $finalPrice = ($discount > 0) ? round($originalPrice * (1 - $discount/100), 2) : $originalPrice;
    $rating = round(3 + (rand(0, 20) / 10), 1);
    $reviews = rand(5, 500);
    
    // 🖼️ ইমেজ URL তৈরি (এখানে আপনার ইমেজ সেট হচ্ছে)
    // আপনার ইমেজ ফাইলগুলো যদি product_1.png, product_2.png এভাবে থাকে
    $image = $baseImageUrl . "product_" . $i . ".jpg";
    
    // যদি jpg হয় তাহলে:
    // $image = $baseImageUrl . "product_" . $i . ".jpg";
    
    // যদি ভিন্ন নামে হয় (যেমন: img1.jpg, img2.jpg):
    // $image = $baseImageUrl . "img" . $i . ".jpg";
    
    $products[] = [
        'id' => $i,
        'name' => $name,
        'category' => $category,
        'description' => $descriptions[array_rand($descriptions)] . ' ' . $name,
        'price' => $finalPrice,
        'original_price' => ($discount > 0) ? $originalPrice : null,
        'discount_percent' => $discount,
        'rating' => $rating,
        'reviews' => $reviews,
        'in_stock_percent' => rand(15, 100),
        'image' => $image,  // ← আপনার ইমেজ এখানে বসবে
        'is_featured' => ($i <= 20) ? true : false
    ];
}

// ফিল্টার
if (isset($_GET['category']) && $_GET['category'] != 'All') {
    $cat = $_GET['category'];
    $products = array_values(array_filter($products, fn($p) => $p['category'] == $cat));
}

if (isset($_GET['search'])) {
    $search = strtolower($_GET['search']);
    $products = array_values(array_filter($products, fn($p) => strpos(strtolower($p['name']), $search) !== false || strpos(strtolower($p['category']), $search) !== false));
}

echo json_encode([
    'success' => true,
    'total_products' => count($products),
    'page' => 1,
    'total_pages' => 1,
    'products' => $products
], JSON_PRETTY_PRINT);
?>