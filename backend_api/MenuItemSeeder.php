<?php
if (!isset($_SERVER['REQUEST_METHOD'])) {
    $_SERVER['REQUEST_METHOD'] = 'GET';
}

require_once 'db.php';

if (!headers_sent()) {
    header('Content-Type: application/json');
}

try {
    // Temporarily disable foreign key constraints to safely clear old items
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 0;");
    $pdo->exec("TRUNCATE TABLE menu_item_ingredients;");
    $pdo->exec("TRUNCATE TABLE menu_items;");
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 1;");

    $pdo->beginTransaction();

    $menuItems = [
        // ============================================================
        // ── BREAKFAST (Category ID: 1) ──────────────────────────────
        // ============================================================
        [
            'id' => 1,
            'category_id' => 1,
            'name' => 'Paratha with Egg',
            'description' => 'Crispy, flaky layered flatbread served with sunny-side-up fried egg and light onion masala.',
            'price' => 60.00,
            'image_url' => 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600&q=80',
            'calories' => 380,
            'prep_time_minutes' => 15,
            'rating' => 4.8,
            'review_count' => 85,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Whole Wheat Flour', 'image_url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Farm Egg', 'image_url' => 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 'quantity_gm' => 60],
                ['name' => 'Pure Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 20],
                ['name' => 'Green Chili & Onion', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 25],
            ]
        ],
        [
            'id' => 2,
            'category_id' => 1,
            'name' => 'Luchi with Aloo Dum',
            'description' => 'Fluffy golden deep-fried puffed bread served with rich, aromatic spiced baby potato gravy.',
            'price' => 80.00,
            'image_url' => 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&q=80',
            'calories' => 420,
            'prep_time_minutes' => 20,
            'rating' => 4.9,
            'review_count' => 94,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Refined Flour Maida', 'image_url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80', 'quantity_gm' => 150],
                ['name' => 'Baby Potatoes', 'image_url' => 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Panch Phoron Spices', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 15],
                ['name' => 'Mustard Oil', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 25],
            ]
        ],
        [
            'id' => 3,
            'category_id' => 1,
            'name' => 'Breakfast Khichuri',
            'description' => 'Comforting slow-cooked fragrant rice and roasted moong dal with turmeric, ginger, and cumin temper.',
            'price' => 100.00,
            'image_url' => 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600&q=80',
            'calories' => 450,
            'prep_time_minutes' => 25,
            'rating' => 4.7,
            'review_count' => 72,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Chinigura Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Roasted Moong Dal', 'image_url' => 'https://images.unsplash.com/photo-1585994192701-f1a505c817ea?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Pure Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 20],
                ['name' => 'Ginger & Cumin Spices', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 4,
            'category_id' => 1,
            'name' => 'Ruti with Bhaji',
            'description' => 'Two soft freshly-puffed handmade flatbreads paired with spiced potato, papaya, and seasonal vegetable stir-fry.',
            'price' => 50.00,
            'image_url' => 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=600&q=80',
            'calories' => 290,
            'prep_time_minutes' => 15,
            'rating' => 4.6,
            'review_count' => 65,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Whole Wheat Atta', 'image_url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Potatoes & Mixed Veggies', 'image_url' => 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&q=80', 'quantity_gm' => 150],
                ['name' => 'Turmeric & Green Chili', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 10],
                ['name' => 'Mustard Oil', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 5,
            'category_id' => 1,
            'name' => 'Omelette Plate',
            'description' => 'Double farm-fresh egg omelette seasoned with chopped red onions, fresh green chilies, coriander, and black pepper.',
            'price' => 70.00,
            'image_url' => 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=600&q=80',
            'calories' => 260,
            'prep_time_minutes' => 15,
            'rating' => 4.7,
            'review_count' => 58,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Fresh Farm Eggs', 'image_url' => 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Red Onions', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Green Chilies & Coriander', 'image_url' => 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80', 'quantity_gm' => 15],
                ['name' => 'Cooking Oil', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 6,
            'category_id' => 1,
            'name' => 'Nashta Combo (Bread, Egg, Jam)',
            'description' => 'Toasted buttery milk bread slices served alongside a sunny fried egg and real fruit strawberry jam.',
            'price' => 90.00,
            'image_url' => 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&q=80',
            'calories' => 350,
            'prep_time_minutes' => 15,
            'rating' => 4.5,
            'review_count' => 44,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'White Sliced Bread', 'image_url' => 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Fried Egg', 'image_url' => 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 'quantity_gm' => 60],
                ['name' => 'Strawberry Jam', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Creamery Butter', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 7,
            'category_id' => 1,
            'name' => 'Suji Halwa',
            'description' => 'Warm sweet semolina pudding roasted in pure desi ghee, infused with cardamom, raisins, and sliced cashews.',
            'price' => 60.00,
            'image_url' => 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&q=80',
            'calories' => 320,
            'prep_time_minutes' => 15,
            'rating' => 4.8,
            'review_count' => 79,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Roasted Semolina Suji', 'image_url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Desi Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Pure Cane Sugar', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 60],
                ['name' => 'Cashews & Cardamom', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],
        [
            'id' => 8,
            'category_id' => 1,
            'name' => 'Cha (Tea) with Biscuit',
            'description' => 'Traditional Bangladeshi spiced milk tea slow-brewed with condensed milk, served with crisp morning biscuits.',
            'price' => 40.00,
            'image_url' => 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&q=80',
            'calories' => 160,
            'prep_time_minutes' => 15,
            'rating' => 4.9,
            'review_count' => 100,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Sylhet Black Tea Leaves', 'image_url' => 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&q=80', 'quantity_gm' => 15],
                ['name' => 'Fresh Whole Milk', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 150],
                ['name' => 'Crushed Cardamom & Ginger', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 5],
                ['name' => 'Morning Tea Biscuits', 'image_url' => 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300&q=80', 'quantity_gm' => 40],
            ]
        ],

        // ============================================================
        // ── LUNCH (Category ID: 2) ──────────────────────────────────
        // ============================================================
        [
            'id' => 9,
            'category_id' => 2,
            'name' => 'Mutton Biryani',
            'description' => 'Slow-cooked aromatic basmati rice layered with tender marinated mutton chunks, caramelized onions, and spiced whole potato.',
            'price' => 380.00,
            'image_url' => 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&q=80',
            'calories' => 780,
            'prep_time_minutes' => 35,
            'rating' => 4.9,
            'review_count' => 98,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Tender Mutton Chunks', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Aged Basmati Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Pure Desi Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Shahi Biryani Spices', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 25],
                ['name' => 'Golden Potato', 'image_url' => 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 'quantity_gm' => 100],
            ]
        ],
        [
            'id' => 10,
            'category_id' => 2,
            'name' => 'Chicken Biryani',
            'description' => 'Classic Dhaka-style chicken biryani cooked with succulent chicken pieces, aromatic spices, potato, and fragrant rice.',
            'price' => 280.00,
            'image_url' => 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
            'calories' => 690,
            'prep_time_minutes' => 30,
            'rating' => 4.8,
            'review_count' => 92,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Bone-in Chicken Pieces', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Chinigura Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Crispy Onion Beresta', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 35],
                ['name' => 'Spiced Potatoes', 'image_url' => 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 'quantity_gm' => 90],
                ['name' => 'Saffron Infused Milk', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],
        [
            'id' => 11,
            'category_id' => 2,
            'name' => 'Plain Rice with Mutton Curry',
            'description' => 'Steamed fragrant white rice served with home-style rich and spicy goat mutton curry with thick gravy.',
            'price' => 320.00,
            'image_url' => 'https://images.unsplash.com/photo-1545247181-516773cae754?w=600&q=80',
            'calories' => 710,
            'prep_time_minutes' => 25,
            'rating' => 4.7,
            'review_count' => 68,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Steamed Miniket Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 280],
                ['name' => 'Mutton Meat', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Onion & Garlic Gravy', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Mustard Oil & Garam Masala', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],
        [
            'id' => 12,
            'category_id' => 2,
            'name' => 'Plain Rice with Chicken Curry',
            'description' => 'Comforting lunch platter of piping hot steamed white rice served with traditional Bengali chicken and potato curry.',
            'price' => 220.00,
            'image_url' => 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&q=80',
            'calories' => 620,
            'prep_time_minutes' => 25,
            'rating' => 4.7,
            'review_count' => 75,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Steamed Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 280],
                ['name' => 'Chicken Curry Cuts', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 220],
                ['name' => 'Diced Potatoes', 'image_url' => 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Cumin & Red Chili Sauce', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 25],
            ]
        ],
        [
            'id' => 13,
            'category_id' => 2,
            'name' => 'Khichuri with Beef',
            'description' => 'Hearty Bhuna Khichuri cooked with kalijira aromatic rice and yellow lentils, topped with slow-cooked spicy tender beef.',
            'price' => 260.00,
            'image_url' => 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600&q=80',
            'calories' => 740,
            'prep_time_minutes' => 30,
            'rating' => 4.9,
            'review_count' => 88,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Kalijira Aromatic Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Moong & Masoor Lentils', 'image_url' => 'https://images.unsplash.com/photo-1585994192701-f1a505c817ea?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Spiced Tender Beef', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Ghee & Fried Onions', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
            ]
        ],
        [
            'id' => 14,
            'category_id' => 2,
            'name' => 'Beef Bhuna',
            'description' => 'Thick, deeply caramelized beef curry slow-braised with roasted onions, ginger-garlic paste, and traditional whole spices.',
            'price' => 240.00,
            'image_url' => 'https://images.unsplash.com/photo-1545247181-516773cae754?w=600&q=80',
            'calories' => 550,
            'prep_time_minutes' => 30,
            'rating' => 4.8,
            'review_count' => 90,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Prime Beef Cuts', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Caramelized Red Onions', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Ginger Garlic Paste', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 25],
                ['name' => 'Roasted Garam Masala', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 15,
            'category_id' => 2,
            'name' => 'Fish Curry with Rice',
            'description' => 'Fresh Rui fish cutlet lightly fried and simmered in a light tomato-cumin broth, served with steamed white rice.',
            'price' => 230.00,
            'image_url' => 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&q=80',
            'calories' => 520,
            'prep_time_minutes' => 25,
            'rating' => 4.6,
            'review_count' => 64,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Fresh Rui Fish', 'image_url' => 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Steamed White Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Tomatoes & Cumin Broth', 'image_url' => 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Mustard Oil & Green Chilies', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 16,
            'category_id' => 2,
            'name' => 'Dal-Bhaat Combo (Rice, Dal, Vegetable, Fish)',
            'description' => 'Wholesome traditional thali complete with steamed rice, thick yellow lentil dal, crispy fried fish, and seasonal vegetable labra.',
            'price' => 190.00,
            'image_url' => 'https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?w=600&q=80',
            'calories' => 610,
            'prep_time_minutes' => 20,
            'rating' => 4.8,
            'review_count' => 82,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Steamed Bhaat Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Yellow Lentil Dal', 'image_url' => 'https://images.unsplash.com/photo-1585994192701-f1a505c817ea?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Crispy Fried Fish', 'image_url' => 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Seasonal Vegetable Labra', 'image_url' => 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&q=80', 'quantity_gm' => 90],
            ]
        ],
        [
            'id' => 17,
            'category_id' => 2,
            'name' => 'Chicken Rezala with Polao',
            'description' => 'Mughlai-style velvety chicken rezala cooked in yogurt, poppy seed, and cashew paste, paired with ghee-infused fragrant polao rice.',
            'price' => 290.00,
            'image_url' => 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&q=80',
            'calories' => 720,
            'prep_time_minutes' => 30,
            'rating' => 4.8,
            'review_count' => 86,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Chicken Quarter Cuts', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 220],
                ['name' => 'Ghee Polao Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Yogurt & Cashew Paste', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 70],
                ['name' => 'Kewra Water & Spices', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 18,
            'category_id' => 2,
            'name' => 'Morog Polao',
            'description' => 'Dhaka heritage chicken pilaf prepared with tender country chicken, kalijira rice, desi ghee, sweet mawa, and boiled egg.',
            'price' => 310.00,
            'image_url' => 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
            'calories' => 760,
            'prep_time_minutes' => 35,
            'rating' => 4.9,
            'review_count' => 95,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Desi Chicken Pieces', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Kalijira Polao Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 240],
                ['name' => 'Pure Desi Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Mawa & Spices', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 25],
                ['name' => 'Boiled Egg', 'image_url' => 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 'quantity_gm' => 50],
            ]
        ],

        // ============================================================
        // ── DINNER (Category ID: 3) ─────────────────────────────────
        // ============================================================
        [
            'id' => 19,
            'category_id' => 3,
            'name' => 'Kacchi Biryani',
            'description' => 'Authentic Old Dhaka raw mutton dum biryani layered with spiced marinated mutton, saffron milk, aloo bukhara, and aloo.',
            'price' => 420.00,
            'image_url' => 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&q=80',
            'calories' => 850,
            'prep_time_minutes' => 40,
            'rating' => 5.0,
            'review_count' => 100,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Marinated Raw Mutton', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 280],
                ['name' => 'Aged Basmati Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 280],
                ['name' => 'Saffron & Desi Ghee', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 35],
                ['name' => 'Spiced Dum Potato', 'image_url' => 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Dried Prunes Aloo Bukhara', 'image_url' => 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],
        [
            'id' => 20,
            'category_id' => 3,
            'name' => 'Beef Tehari',
            'description' => 'Pungent mustard oil aromatic rice pilaf tossed with tender bite-sized beef cubes, slit green chilies, and special tehari masala.',
            'price' => 260.00,
            'image_url' => 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
            'calories' => 710,
            'prep_time_minutes' => 30,
            'rating' => 4.9,
            'review_count' => 88,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Bite-sized Beef Cubes', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Chinigura Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 240],
                ['name' => 'Mustard Oil', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Slit Green Chilies', 'image_url' => 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 21,
            'category_id' => 3,
            'name' => 'Grilled Chicken with Naan',
            'description' => 'Quarter char-grilled chicken marinated in spiced yogurt and garlic, served with fluffy clay-oven tandoori naan and mint chutney.',
            'price' => 250.00,
            'image_url' => 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&q=80',
            'calories' => 580,
            'prep_time_minutes' => 25,
            'rating' => 4.8,
            'review_count' => 92,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Char-Grilled Chicken', 'image_url' => 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Tandoori Naan', 'image_url' => 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Spiced Yogurt Marinade', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Mint Coriander Chutney', 'image_url' => 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300&q=80', 'quantity_gm' => 30],
            ]
        ],
        [
            'id' => 22,
            'category_id' => 3,
            'name' => 'Mutton Rezala with Polao',
            'description' => 'Royal dinner delicacy of tender goat mutton cooked in a mild white yogurt and nut gravy with whole red chilies, paired with fragrant polao.',
            'price' => 360.00,
            'image_url' => 'https://images.unsplash.com/photo-1545247181-516773cae754?w=600&q=80',
            'calories' => 820,
            'prep_time_minutes' => 35,
            'rating' => 4.9,
            'review_count' => 78,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Tender Goat Mutton', 'image_url' => 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Shahi Polao Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Cashew & Poppy Paste', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 50],
                ['name' => 'Desi Ghee & Spices', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 25],
            ]
        ],
        [
            'id' => 23,
            'category_id' => 3,
            'name' => 'Chili Chicken Fried Rice',
            'description' => 'Wok-tossed egg and vegetable fried rice served with tangy, spicy Indo-Chinese chili chicken cubes and capsicum.',
            'price' => 280.00,
            'image_url' => 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&q=80',
            'calories' => 640,
            'prep_time_minutes' => 20,
            'rating' => 4.7,
            'review_count' => 84,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Wok Fried Rice', 'image_url' => 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Boneless Chicken Cubes', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Bell Peppers & Onion', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 60],
                ['name' => 'Soy & Chili Glaze', 'image_url' => 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80', 'quantity_gm' => 30],
            ]
        ],
        [
            'id' => 24,
            'category_id' => 3,
            'name' => 'Chicken Curry with Ruti',
            'description' => 'Three warm handmade whole-wheat rutis served with home-style spiced chicken curry and fresh sliced salad.',
            'price' => 180.00,
            'image_url' => 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=600&q=80',
            'calories' => 480,
            'prep_time_minutes' => 20,
            'rating' => 4.6,
            'review_count' => 56,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Whole Wheat Rutis', 'image_url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Chicken Curry Pieces', 'image_url' => 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Spiced Onion Gravy', 'image_url' => 'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Fresh Salad', 'image_url' => 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&q=80', 'quantity_gm' => 40],
            ]
        ],
        [
            'id' => 25,
            'category_id' => 3,
            'name' => 'Shorshe Ilish with Rice',
            'description' => 'Premium Padma Hilsa steak cooked in freshly-ground yellow and black mustard paste, green chilies, and virgin mustard oil with white rice.',
            'price' => 450.00,
            'image_url' => 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&q=80',
            'calories' => 680,
            'prep_time_minutes' => 30,
            'rating' => 5.0,
            'review_count' => 99,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Padma Ilish Steak', 'image_url' => 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Steamed Miniket Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Ground Mustard Paste', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Mustard Oil & Green Chilies', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],

        // ============================================================
        // ── DESSERT (Category ID: 4) ────────────────────────────────
        // ============================================================
        [
            'id' => 26,
            'category_id' => 4,
            'name' => 'Roshogolla',
            'description' => 'Two soft, spongy Bengali cottage cheese (chhena) balls soaked in delicate cardamom-flavored sugar syrup.',
            'price' => 80.00,
            'image_url' => 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&q=80',
            'calories' => 220,
            'prep_time_minutes' => 15,
            'rating' => 4.9,
            'review_count' => 82,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Fresh Cow Milk Chhena', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 120],
                ['name' => 'Refined Sugar Syrup', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Cardamom & Rose Essence', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 5],
            ]
        ],
        [
            'id' => 27,
            'category_id' => 4,
            'name' => 'Mishti Doi',
            'description' => 'Traditional caramel sweet yogurt naturally fermented in an earthen clay pot with rich, thick creamy texture.',
            'price' => 90.00,
            'image_url' => 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600&q=80',
            'calories' => 260,
            'prep_time_minutes' => 15,
            'rating' => 5.0,
            'review_count' => 96,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Reduced Whole Milk', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Caramelized Cane Sugar', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 45],
                ['name' => 'Yogurt Culture', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 28,
            'category_id' => 4,
            'name' => 'Chomchom',
            'description' => 'Heritage Porabari-style oval sweetmeat with a caramelized golden exterior, dusted with dried milk mawa.',
            'price' => 100.00,
            'image_url' => 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=600&q=80',
            'calories' => 280,
            'prep_time_minutes' => 15,
            'rating' => 4.8,
            'review_count' => 70,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Dense Chhena', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 130],
                ['name' => 'Sugar & Saffron Syrup', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Grated Khoya Mawa', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 25],
            ]
        ],
        [
            'id' => 29,
            'category_id' => 4,
            'name' => 'Firni',
            'description' => 'Classic slow-cooked rice pudding made with coarsely ground aromatic rice, whole milk, saffron, and slivered pistachios.',
            'price' => 85.00,
            'image_url' => 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&q=80',
            'calories' => 240,
            'prep_time_minutes' => 15,
            'rating' => 4.9,
            'review_count' => 88,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Coarse Kalijira Rice', 'image_url' => 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Full-Cream Milk', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Sugar & Saffron', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 35],
                ['name' => 'Pistachio & Almond Flakes', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 15],
            ]
        ],
        [
            'id' => 30,
            'category_id' => 4,
            'name' => 'Gulab Jamun',
            'description' => 'Golden fried milk-solid dumplings soaked warm in sweet saffron and rose water syrup.',
            'price' => 75.00,
            'image_url' => 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=600&q=80',
            'calories' => 260,
            'prep_time_minutes' => 15,
            'rating' => 4.8,
            'review_count' => 92,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Khoya Milk Solids', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 100],
                ['name' => 'Rose Sugar Syrup', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 80],
                ['name' => 'Ghee for Frying', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Cardamom Powder', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 5],
            ]
        ],

        // ============================================================
        // ── DRINKS (Category ID: 5) ─────────────────────────────────
        // ============================================================
        [
            'id' => 31,
            'category_id' => 5,
            'name' => 'Borhani',
            'description' => 'Traditional wedding-style spiced savory yogurt drink blended with mint, roasted cumin, black salt, and mustard.',
            'price' => 70.00,
            'image_url' => 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=600&q=80',
            'calories' => 120,
            'prep_time_minutes' => 15,
            'rating' => 4.9,
            'review_count' => 94,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Sour Yogurt', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Fresh Mint & Coriander', 'image_url' => 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300&q=80', 'quantity_gm' => 25],
                ['name' => 'Roasted Cumin & Black Salt', 'image_url' => 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&q=80', 'quantity_gm' => 10],
                ['name' => 'Mustard Paste & Green Chili', 'image_url' => 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80', 'quantity_gm' => 10],
            ]
        ],
        [
            'id' => 32,
            'category_id' => 5,
            'name' => 'Lassi',
            'description' => 'Thick, refreshing sweet yogurt smoothie churned with ice, rose water, and topped with malai cream.',
            'price' => 80.00,
            'image_url' => 'https://images.unsplash.com/photo-1558857563-b371033873b8?w=600&q=80',
            'calories' => 180,
            'prep_time_minutes' => 15,
            'rating' => 4.8,
            'review_count' => 88,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Fresh Sweet Curd', 'image_url' => 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Cane Sugar', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 30],
                ['name' => 'Rose Water & Ice', 'image_url' => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Malai Cream', 'image_url' => 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 'quantity_gm' => 20],
            ]
        ],
        [
            'id' => 33,
            'category_id' => 5,
            'name' => 'Fresh Lime Water',
            'description' => 'Chilled freshly-squeezed Kagzi lime juice with a hint of mint, rock salt, and light sugar syrup.',
            'price' => 50.00,
            'image_url' => 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=600&q=80',
            'calories' => 60,
            'prep_time_minutes' => 15,
            'rating' => 4.7,
            'review_count' => 76,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Fresh Lime Juice', 'image_url' => 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=300&q=80', 'quantity_gm' => 40],
                ['name' => 'Chilled Water', 'image_url' => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=300&q=80', 'quantity_gm' => 200],
                ['name' => 'Sugar Syrup & Rock Salt', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 20],
                ['name' => 'Mint Sprigs', 'image_url' => 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300&q=80', 'quantity_gm' => 5],
            ]
        ],
        [
            'id' => 34,
            'category_id' => 5,
            'name' => 'Cola',
            'description' => 'Ice-cold refreshing carbonated cola beverage served in a chilled glass with ice cubes.',
            'price' => 50.00,
            'image_url' => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&q=80',
            'calories' => 140,
            'prep_time_minutes' => 15,
            'rating' => 4.6,
            'review_count' => 60,
            'is_popular' => 0,
            'ingredients' => [
                ['name' => 'Carbonated Cola Drink', 'image_url' => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=300&q=80', 'quantity_gm' => 250],
                ['name' => 'Crushed Ice', 'image_url' => 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=300&q=80', 'quantity_gm' => 50],
                ['name' => 'Lemon Slice', 'image_url' => 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=300&q=80', 'quantity_gm' => 10],
            ]
        ],
        [
            'id' => 35,
            'category_id' => 5,
            'name' => 'Mango Juice',
            'description' => '100% natural thick juice extracted from fresh Rajshahi Fazli & Himsagar mangoes, served chilled.',
            'price' => 90.00,
            'image_url' => 'https://images.unsplash.com/photo-1546173159-315724a31696?w=600&q=80',
            'calories' => 150,
            'prep_time_minutes' => 15,
            'rating' => 4.9,
            'review_count' => 95,
            'is_popular' => 1,
            'ingredients' => [
                ['name' => 'Fresh Mango Pulp', 'image_url' => 'https://images.unsplash.com/photo-1546173159-315724a31696?w=300&q=80', 'quantity_gm' => 180],
                ['name' => 'Chilled Water', 'image_url' => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=300&q=80', 'quantity_gm' => 70],
                ['name' => 'Cane Sugar', 'image_url' => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300&q=80', 'quantity_gm' => 15],
                ['name' => 'Crushed Ice', 'image_url' => 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=300&q=80', 'quantity_gm' => 35],
            ]
        ],
    ];

    $itemStmt = $pdo->prepare("
        INSERT INTO menu_items (id, category_id, name, description, price, image_url, calories, prep_time_minutes, rating, review_count, is_popular)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");

    $ingStmt = $pdo->prepare("
        INSERT INTO menu_item_ingredients (menu_item_id, ingredient_name, image_url, quantity_gm, base_servings)
        VALUES (?, ?, ?, ?, 1)
    ");

    $totalItems = 0;
    $totalIngredients = 0;

    foreach ($menuItems as $item) {
        $itemStmt->execute([
            $item['id'],
            $item['category_id'],
            $item['name'],
            $item['description'],
            $item['price'],
            $item['image_url'],
            $item['calories'],
            $item['prep_time_minutes'],
            $item['rating'],
            $item['review_count'],
            $item['is_popular']
        ]);
        $totalItems++;

        foreach ($item['ingredients'] as $ing) {
            $ingStmt->execute([
                $item['id'],
                $ing['name'],
                $ing['image_url'],
                $ing['quantity_gm']
            ]);
            $totalIngredients++;
        }
    }

    $pdo->commit();

    echo json_encode([
        'status' => 'success',
        'message' => "Seeded successfully! Total items: $totalItems, Total ingredients: $totalIngredients.",
        'items_seeded' => $totalItems,
        'ingredients_seeded' => $totalIngredients,
    ]);

} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    if (!headers_sent()) {
        http_response_code(500);
    }
    echo json_encode([
        'status' => 'error',
        'message' => 'Seeding failed: ' . $e->getMessage()
    ]);
}
?>
