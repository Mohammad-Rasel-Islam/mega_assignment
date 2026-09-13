-- ============================================================
--  shop_app_db.sql  ·  FoodieExpress Restaurant App
--  ============================================================
--  HOW TO IMPORT:
--    1. Open phpMyAdmin → http://localhost/phpmyadmin
--    2. Click "Import" tab
--    3. Choose this file → Click "Go"
--  OR via command line:
--    mysql -u root -p < shop_app_db.sql
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET FOREIGN_KEY_CHECKS = 0;
SET time_zone = "+00:00";

-- ── Create & Select Database ────────────────────────────────
CREATE DATABASE IF NOT EXISTS `shop_app_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `shop_app_db`;

-- ── Drop existing tables (clean reinstall) ──────────────────
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `favorites`;
DROP TABLE IF EXISTS `addresses`;
DROP TABLE IF EXISTS `menu_item_ingredients`;
DROP TABLE IF EXISTS `menu_items`;
DROP TABLE IF EXISTS `banners`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;

-- ============================================================
--  TABLE: users
-- ============================================================
CREATE TABLE `users` (
  `id`             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(100)  NOT NULL,
  `email`          VARCHAR(150)  NOT NULL,
  `password`       VARCHAR(255)  NOT NULL,
  `remember_token` VARCHAR(100)  DEFAULT NULL,
  `photo_url`      VARCHAR(500)  DEFAULT NULL,
  `created_at`     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Demo user  (password: password123)
INSERT INTO `users` (`name`, `email`, `password`) VALUES
('Demo User',  'demo@food.com',  '$2y$10$zgqDoNcrszs8O7.Db99SfOZQhs0abRNqZQBKxYHu1wCe9itLsgX7W'),
('John Doe',   'john@food.com',  '$2y$10$zgqDoNcrszs8O7.Db99SfOZQhs0abRNqZQBKxYHu1wCe9itLsgX7W'),
('Test User',  'test@test.com',  '$2y$10$zgqDoNcrszs8O7.Db99SfOZQhs0abRNqZQBKxYHu1wCe9itLsgX7W');

-- ============================================================
--  TABLE: categories
-- ============================================================
CREATE TABLE `categories` (
  `id`        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `name`      VARCHAR(100)  NOT NULL,
  `icon`      VARCHAR(100)  DEFAULT NULL,
  `image_url` VARCHAR(500)  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`id`, `name`, `icon`, `image_url`) VALUES
(1, 'Breakfast', '🍳', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=500&q=80'),
(2, 'Lunch',     '🍱', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80'),
(3, 'Dinner',    '🍽️', 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80'),
(4, 'Dessert',   '🍰', 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&q=80'),
(5, 'Drinks',    '🥤', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=500&q=80'),
(6, 'Snacks',    '🍟', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80');

-- ============================================================
--  TABLE: banners
-- ============================================================
CREATE TABLE `banners` (
  `id`          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(150)  NOT NULL,
  `subtitle`    VARCHAR(255)  NOT NULL,
  `button_text` VARCHAR(50)   NOT NULL DEFAULT 'Order Now',
  `image_url`   VARCHAR(500)  NOT NULL,
  `bg_color`    VARCHAR(20)   NOT NULL DEFAULT '#FF4757',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `banners` (`id`, `title`, `subtitle`, `button_text`, `image_url`, `bg_color`) VALUES
(1, '30% OFF Today!',   'Delicious Gourmet Meals',      'Order Now',   'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=700&q=80', '#FF4757'),
(2, 'Chef\'s Special',  'Fresh & Healthy Buddha Bowls', 'Explore',     'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=700&q=80', '#2ED573'),
(3, 'Sweet Cravings',   'Artisan Desserts & Pastries',  'Get 20% Off', 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=700&q=80', '#FFA502'),
(4, 'Free Delivery',    'On All Orders Over ৳500',      'Order Now',   'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=700&q=80', '#5352ED');

-- ============================================================
--  TABLE: menu_items
-- ============================================================
CREATE TABLE `menu_items` (
  `id`                INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `category_id`       INT UNSIGNED  NOT NULL,
  `name`              VARCHAR(200)  NOT NULL,
  `description`       TEXT          DEFAULT NULL,
  `price`             DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `image_url`         VARCHAR(500)  NOT NULL,
  `calories`          INT UNSIGNED  NOT NULL DEFAULT 0,
  `prep_time_minutes` INT UNSIGNED  NOT NULL DEFAULT 15,
  `rating`            DECIMAL(3,1)  NOT NULL DEFAULT 4.5,
  `review_count`      INT UNSIGNED  NOT NULL DEFAULT 0,
  `is_popular`        TINYINT(1)    NOT NULL DEFAULT 0,
  `created_at`        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `menu_items` (`id`,`category_id`,`name`,`description`,`price`,`image_url`,`calories`,`prep_time_minutes`,`rating`,`review_count`,`is_popular`) VALUES

-- ── BREAKFAST (cat 1) ────────────────────────────────────────
(1,  1, 'Avocado Toast with Poached Eggs',
 'Crispy sourdough bread topped with creamy smashed avocado, poached organic eggs, red pepper flakes, and microgreens.',
 450.00, 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&q=80', 380, 15, 4.8, 142, 1),

(2,  1, 'Fluffy Blueberry Pancakes',
 'Stack of fluffy golden pancakes layered with fresh blueberries, whipped maple butter, and organic syrup.',
 380.00, 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&q=80', 520, 20, 4.9, 215, 1),

(3,  1, 'Classic Eggs Benedict',
 'Toasted English muffins topped with Canadian bacon, soft poached eggs, and rich homemade Hollandaise sauce.',
 520.00, 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=600&q=80', 610, 25, 4.7, 98, 0),

(4,  1, 'Acai Smoothie Bowl',
 'Frozen acai bowl topped with banana, fresh berries, chia seeds, coconut flakes, and granola.',
 420.00, 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=600&q=80', 310, 10, 4.8, 175, 1),

(5,  1, 'Mediterranean Omelette',
 'Three-egg omelette filled with fresh spinach, sun-dried tomatoes, kalamata olives, and crumbled feta cheese.',
 390.00, 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=600&q=80', 440, 15, 4.6, 84, 0),

(6,  1, 'Belgian Waffles & Cream',
 'Crisp Belgian waffle dusted with powdered sugar, topped with Chantilly cream and fresh raspberries.',
 360.00, 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&q=80', 490, 18, 4.7, 130, 0),

(7,  1, 'Classic French Toast',
 'Thick-cut brioche soaked in vanilla custard, pan-fried golden, served with powdered sugar and berry compote.',
 350.00, 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=600&q=80', 470, 15, 4.7, 110, 0),

-- ── LUNCH (cat 2) ────────────────────────────────────────────
(8,  2, 'Grilled Chicken Caesar Salad',
 'Tender grilled chicken breast over crisp romaine lettuce, garlic croutons, parmesan shavings, and house Caesar dressing.',
 480.00, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=80', 420, 15, 4.8, 260, 1),

(9,  2, 'Gourmet Wagyu Beef Burger',
 'Juicy Wagyu beef patty with melted cheddar, caramelized onions, smoked bacon, and truffle mayo on a brioche bun.',
 650.00, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80', 780, 20, 4.9, 340, 1),

(10, 2, 'Salmon Poke Bowl',
 'Fresh sashimi-grade salmon, edamame, avocado, cucumber, sushi rice, and ponzu drizzle.',
 590.00, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80', 510, 15, 4.9, 188, 1),

(11, 2, 'Crispy Buffalo Chicken Wrap',
 'Crispy fried chicken tenders tossed in spicy buffalo sauce, wrapped with lettuce, tomatoes, and ranch dressing.',
 420.00, 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=600&q=80', 560, 15, 4.6, 112, 0),

(12, 2, 'Truffle Mushroom Risotto',
 'Creamy Arborio rice slow-cooked with wild mushrooms, black truffle oil, white wine, and aged parmesan.',
 550.00, 'https://images.unsplash.com/photo-1633964913295-ceb43826e7c9?w=600&q=80', 490, 25, 4.8, 156, 0),

(13, 2, 'Philly Cheesesteak Sandwich',
 'Thinly sliced ribeye sautéed with peppers and onions, smothered in melted provolone on a toasted hoagie roll.',
 490.00, 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&q=80', 680, 18, 4.7, 129, 0),

(14, 2, 'Spicy Tuna Sushi Rolls',
 'Fresh spicy tuna, cucumber, avocado rolled in seasoned sushi rice with sesame seeds and sriracha mayo.',
 540.00, 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=600&q=80', 420, 20, 4.8, 175, 0),

-- ── DINNER (cat 3) ───────────────────────────────────────────
(15, 3, 'Pan-Seared Ribeye Steak',
 'Prime 10oz ribeye pan-seared with garlic herb butter, served with roasted asparagus and garlic mashed potatoes.',
 950.00, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80', 820, 30, 4.9, 310, 1),

(16, 3, 'Grilled Atlantic Salmon',
 'Wild Atlantic salmon fillet grilled with lemon dill butter, served over quinoa and steamed broccoli.',
 780.00, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&q=80', 540, 22, 4.8, 205, 1),

(17, 3, 'Creamy Fettuccine Alfredo',
 'Handmade fettuccine tossed in a rich butter, heavy cream, and Parmigiano-Reggiano sauce with garlic chicken.',
 580.00, 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&q=80', 690, 20, 4.7, 168, 0),

(18, 3, 'Neapolitan Margherita Pizza',
 'Wood-fired sourdough pizza topped with San Marzano tomato sauce, buffalo mozzarella, basil, and olive oil.',
 620.00, 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600&q=80', 650, 20, 4.9, 290, 1),

(19, 3, 'Slow-Cooked BBQ Pork Ribs',
 'Fall-off-the-bone pork ribs glazed in honey hickory BBQ sauce, served with coleslaw and fries.',
 850.00, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80', 850, 35, 4.8, 177, 1),

(20, 3, 'Vegetable Thai Green Curry',
 'Aromatic coconut milk green curry loaded with tofu, bamboo shoots, Thai basil, and jasmine rice.',
 460.00, 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=600&q=80', 430, 20, 4.6, 92, 0),

(21, 3, 'Butter Chicken with Naan',
 'Tender chicken pieces simmered in creamy tomato-butter masala sauce, served with soft garlic naan bread.',
 520.00, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&q=80', 600, 25, 4.9, 320, 1),

-- ── DESSERT (cat 4) ──────────────────────────────────────────
(22, 4, 'Molten Chocolate Lava Cake',
 'Decadent warm chocolate cake with a molten liquid center, served with vanilla bean ice cream.',
 320.00, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=600&q=80', 480, 15, 4.9, 275, 1),

(23, 4, 'New York Cheesecake',
 'Classic creamy NY-style cheesecake with graham cracker crust and fresh strawberry compote.',
 350.00, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=600&q=80', 440, 10, 4.8, 195, 1),

(24, 4, 'Authentic Italian Tiramisu',
 'Layers of espresso-soaked ladyfingers and whipped mascarpone cream, dusted with Dutch cocoa.',
 340.00, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&q=80', 390, 12, 4.8, 160, 0),

(25, 4, 'Crispy Churros with Chocolate',
 'Golden crispy Spanish churros rolled in cinnamon sugar, served with warm chocolate dip.',
 290.00, 'https://images.unsplash.com/photo-1624371414361-e670ef480012?w=600&q=80', 360, 12, 4.7, 120, 0),

(26, 4, 'Matcha Green Tea Ice Cream',
 'Artisan Japanese ceremonial matcha ice cream served with sweet red bean paste and waffle cone.',
 260.00, 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=600&q=80', 280, 5, 4.6, 88, 0),

(27, 4, 'French Macarons (6 Pcs)',
 'Assorted delicate French almond macarons filled with chocolate ganache, pistachio, and raspberry.',
 380.00, 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=600&q=80', 320, 5, 4.9, 140, 1),

(28, 4, 'Mango Panna Cotta',
 'Silky Italian panna cotta with fresh Alphonso mango coulis and passion fruit drizzle.',
 310.00, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600&q=80', 300, 8, 4.7, 95, 0),

-- ── DRINKS (cat 5) ───────────────────────────────────────────
(29, 5, 'Iced Caramel Macchiato',
 'Rich espresso layered with cold milk, vanilla syrup, and a buttery caramel drizzle over ice.',
 250.00, 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=600&q=80', 220, 5, 4.8, 310, 1),

(30, 5, 'Fresh Passionfruit Mojito',
 'Hand-muddled passionfruit, fresh mint leaves, lime juice, sparkling soda water, and crushed ice.',
 220.00, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&q=80', 140, 5, 4.9, 185, 1),

(31, 5, 'Mango Passion Smoothie',
 'Creamy tropical smoothie blended with ripe Alphonso mangoes, passionfruit, and Greek yogurt.',
 240.00, 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=600&q=80', 260, 5, 4.7, 145, 0),

(32, 5, 'Classic Milk Bubble Tea',
 'Brewed Assam black tea mixed with milk, cane sugar, and chewy brown sugar tapioca boba pearls.',
 230.00, 'https://images.unsplash.com/photo-1558857563-b371033873b8?w=600&q=80', 310, 8, 4.8, 220, 1),

(33, 5, 'Matcha Green Tea Latte',
 'Whisked Japanese ceremonial matcha powder combined with steamed oat milk and agave nectar.',
 260.00, 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=600&q=80', 190, 6, 4.6, 95, 0),

(34, 5, 'Cold Brew Nitro Coffee',
 'Slow-steeped 24-hour cold brew infused with nitrogen for a velvet smooth cascading foam finish.',
 270.00, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600&q=80', 15, 5, 4.9, 160, 0),

(35, 5, 'Strawberry Lemonade',
 'Fresh-squeezed lemonade blended with ripe strawberry puree, mint sprigs, and honey syrup.',
 200.00, 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=600&q=80', 160, 5, 4.7, 130, 0),

-- ── SNACKS (cat 6) ───────────────────────────────────────────
(36, 6, 'Crispy French Fries & Dips',
 'Golden double-fried cut potatoes tossed in sea salt, served with garlic aioli and spicy ketchup.',
 220.00, 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&q=80', 380, 12, 4.7, 190, 1),

(37, 6, 'Loaded Beef Nachos Supreme',
 'Crispy tortilla chips piled high with seasoned beef, melted cheese, jalapeños, pico de gallo, and sour cream.',
 450.00, 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&q=80', 710, 15, 4.9, 230, 1),

(38, 6, 'Crispy Chicken Wings (8 Pcs)',
 'Jumbo chicken wings fried crispy, tossed in garlic parmesan or buffalo sauce with ranch dip.',
 480.00, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&q=80', 640, 18, 4.8, 280, 1),

(39, 6, 'Mozzarella Cheese Sticks (6 Pcs)',
 'Golden breaded mozzarella sticks with stretch melt interior, served with warm marinara dipping sauce.',
 320.00, 'https://images.unsplash.com/photo-1531749668001-75659ae6f79e?w=600&q=80', 420, 12, 4.6, 115, 0),

(40, 6, 'Crispy Vegetable Spring Rolls',
 'Golden Asian spring rolls packed with shredded cabbage, carrots, mushrooms, and sweet chili sauce.',
 260.00, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80', 290, 12, 4.7, 85, 0),

(41, 6, 'Garlic Parmesan Knot Bread',
 'Oven-baked fluffy bread knots brushed with garlic butter, fresh parsley, and grated parmesan.',
 240.00, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&q=80', 340, 15, 4.8, 105, 0),

(42, 6, 'Spicy Jalapeño Poppers (6 Pcs)',
 'Fresh jalapeños stuffed with cream cheese and cheddar, breaded golden and served with sour cream dip.',
 300.00, 'https://images.unsplash.com/photo-1625944230945-1b7dd3b949ab?w=600&q=80', 390, 12, 4.7, 98, 0);

-- ============================================================
--  TABLE: menu_item_ingredients
-- ============================================================
CREATE TABLE `menu_item_ingredients` (
  `id`              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `menu_item_id`    INT UNSIGNED  NOT NULL,
  `ingredient_name` VARCHAR(150)  NOT NULL,
  `image_url`       VARCHAR(500)  NOT NULL,
  `quantity_gm`     INT UNSIGNED  NOT NULL DEFAULT 50,
  `base_servings`   INT UNSIGNED  NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ingr_menu_item` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `menu_item_ingredients` (`id`,`menu_item_id`,`ingredient_name`,`image_url`,`quantity_gm`,`base_servings`) VALUES
-- Item 1: Avocado Toast
(1,  1, 'Organic Avocado',    'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300&q=80', 120, 1),
(2,  1, 'Poached Eggs',       'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 100, 1),
(3,  1, 'Sourdough Bread',    'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  80, 1),
(4,  1, 'Extra Virgin Olive Oil','https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80',15, 1),
-- Item 2: Blueberry Pancakes
(5,  2, 'Fresh Blueberries',  'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=300&q=80',  60, 1),
(6,  2, 'Maple Syrup',        'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&q=80',  45, 1),
(7,  2, 'Whipped Butter',     'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  20, 1),
(8,  2, 'Pancake Mix',        'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=300&q=80', 150, 1),
-- Item 3: Eggs Benedict
(9,  3, 'Poached Eggs',       'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 100, 1),
(10, 3, 'Hollandaise Sauce',  'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=300&q=80',  50, 1),
(11, 3, 'Canadian Bacon',     'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=300&q=80',  70, 1),
(12, 3, 'English Muffin',     'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  65, 1),
-- Item 4: Acai Bowl
(13, 4, 'Acai Berry Puree',   'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=300&q=80', 180, 1),
(14, 4, 'Fresh Strawberries', 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300&q=80',  50, 1),
(15, 4, 'Organic Granola',    'https://images.unsplash.com/photo-1517093747831-4b443076b30e?w=300&q=80',  40, 1),
(16, 4, 'Chia Seeds',         'https://images.unsplash.com/photo-1514733670139-4d87a1941d55?w=300&q=80',  15, 1),
-- Item 5: Mediterranean Omelette
(17, 5, 'Farm Fresh Eggs',    'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=300&q=80', 150, 1),
(18, 5, 'Feta Cheese',        'https://images.unsplash.com/photo-1559561853-08451507cbe7?w=300&q=80',  40, 1),
(19, 5, 'Baby Spinach',       'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300&q=80',  30, 1),
(20, 5, 'Sun-Dried Tomatoes', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80',  25, 1),
-- Item 6: Belgian Waffles
(21, 6, 'Waffle Batter',      'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=300&q=80', 140, 1),
(22, 6, 'Fresh Raspberries',  'https://images.unsplash.com/photo-1577069861033-55d04ace42f7?w=300&q=80',  45, 1),
(23, 6, 'Chantilly Cream',    'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  30, 1),
-- Item 8: Caesar Salad
(24, 8, 'Grilled Chicken Breast','https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80',150,1),
(25, 8, 'Romaine Lettuce',    'https://images.unsplash.com/photo-1556781266-70e6c4c0627d?w=300&q=80', 100, 1),
(26, 8, 'Parmesan Shavings',  'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=300&q=80',  25, 1),
(27, 8, 'Garlic Croutons',    'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  35, 1),
-- Item 9: Wagyu Burger
(28, 9, 'Wagyu Beef Patty',   'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 200, 1),
(29, 9, 'Brioche Bun',        'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  80, 1),
(30, 9, 'Aged Cheddar Cheese','https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?w=300&q=80',  30, 1),
(31, 9, 'Crispy Bacon',       'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=300&q=80',  25, 1),
-- Item 10: Salmon Poke Bowl
(32,10, 'Fresh Salmon Fillet', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80', 140, 1),
(33,10, 'Sushi Rice',          'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=300&q=80', 120, 1),
(34,10, 'Sliced Avocado',      'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300&q=80',  60, 1),
(35,10, 'Edamame Beans',       'https://images.unsplash.com/photo-1551462147-37885acc36f1?w=300&q=80',  40, 1),
-- Item 11: Buffalo Wrap
(36,11, 'Crispy Chicken Tenders','https://images.unsplash.com/photo-1562967914-608f82629710?w=300&q=80', 160, 1),
(37,11, 'Tortilla Wrap',        'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  75, 1),
(38,11, 'Buffalo Sauce',        'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&q=80',  30, 1),
(39,11, 'Creamy Ranch',         'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  25, 1),
-- Item 12: Truffle Risotto
(40,12, 'Arborio Rice',         'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=300&q=80', 130, 1),
(41,12, 'Wild Mushrooms',       'https://images.unsplash.com/photo-1504470695779-75300268aa0e?w=300&q=80',  80, 1),
(42,12, 'Black Truffle Oil',    'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80',  15, 1),
(43,12, 'Parmigiano Reggiano',  'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=300&q=80',  35, 1),
-- Item 15: Ribeye Steak
(44,15, 'Prime Ribeye Steak',   'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 300, 1),
(45,15, 'Garlic Herb Butter',   'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  30, 1),
(46,15, 'Fresh Asparagus',      'https://images.unsplash.com/photo-1515471209610-e3f170e17812?w=300&q=80',  80, 1),
(47,15, 'Mashed Potatoes',      'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300&q=80', 120, 1),
-- Item 16: Atlantic Salmon
(48,16, 'Atlantic Salmon Fillet','https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80',200, 1),
(49,16, 'Lemon Dill Butter',    'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  25, 1),
(50,16, 'Organic Quinoa',       'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80', 100, 1),
(51,16, 'Steamed Broccoli',     'https://images.unsplash.com/photo-1459411621453-7b0316791141?w=300&q=80',  80, 1),
-- Item 18: Margherita Pizza
(52,18, 'Sourdough Pizza Dough','https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80', 220, 1),
(53,18, 'Buffalo Mozzarella',   'https://images.unsplash.com/photo-1559561853-08451507cbe7?w=300&q=80', 100, 1),
(54,18, 'San Marzano Tomatoes', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80',  80, 1),
(55,18, 'Fresh Basil Leaves',   'https://images.unsplash.com/photo-1608797178974-15b35a640579?w=300&q=80',  10, 1),
-- Item 21: Butter Chicken
(56,21, 'Chicken Breast Pieces','https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80', 200, 1),
(57,21, 'Butter Masala Gravy',  'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=300&q=80', 120, 1),
(58,21, 'Garlic Naan Bread',    'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  80, 1),
(59,21, 'Fresh Cream',          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  30, 1),
-- Item 22: Lava Cake
(60,22, 'Belgian Dark Chocolate','https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=300&q=80',  80, 1),
(61,22, 'Vanilla Bean Ice Cream','https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=300&q=80', 70, 1),
(62,22, 'Butter & Flour',       'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  50, 1),
(63,22, 'Cocoa Powder',         'https://images.unsplash.com/photo-1586495777744-4e6232bf4553?w=300&q=80',  15, 1),
-- Item 23: NY Cheesecake
(64,23, 'Cream Cheese',         'https://images.unsplash.com/photo-1559561853-08451507cbe7?w=300&q=80', 120, 1),
(65,23, 'Graham Cracker Crust', 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  60, 1),
(66,23, 'Strawberry Compote',   'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300&q=80',  40, 1),
-- Item 24: Tiramisu
(67,24, 'Mascarpone Cheese',    'https://images.unsplash.com/photo-1559561853-08451507cbe7?w=300&q=80',  90, 1),
(68,24, 'Savoiardi Ladyfingers','https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300&q=80',  50, 1),
(69,24, 'Espresso Coffee',      'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=300&q=80',  30, 1),
(70,24, 'Cocoa Powder',         'https://images.unsplash.com/photo-1586495777744-4e6232bf4553?w=300&q=80',  10, 1),
-- Item 29: Caramel Macchiato
(71,29, 'Arabica Espresso Shot','https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=300&q=80',  40, 1),
(72,29, 'Fresh Whole Milk',     'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80', 180, 1),
(73,29, 'Caramel Drizzle',      'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&q=80',  20, 1),
(74,29, 'Vanilla Syrup',        'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&q=80',  15, 1),
-- Item 30: Passionfruit Mojito
(75,30, 'Passionfruit Pulp',    'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=300&q=80',  60, 1),
(76,30, 'Fresh Mint Leaves',    'https://images.unsplash.com/photo-1608797178974-15b35a640579?w=300&q=80',  10, 1),
(77,30, 'Sparkling Water',      'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=300&q=80', 200, 1),
(78,30, 'Fresh Lime Juice',     'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80',  25, 1),
-- Item 32: Bubble Tea
(79,32, 'Assam Black Tea',      'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&q=80', 150, 1),
(80,32, 'Tapioca Boba Pearls',  'https://images.unsplash.com/photo-1558857563-b371033873b8?w=300&q=80',  60, 1),
(81,32, 'Condensed Milk',       'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  40, 1),
-- Item 36: French Fries
(82,36, 'Double-Fried Potatoes','https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=300&q=80', 200, 1),
(83,36, 'Garlic Aioli Dip',     'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  35, 1),
(84,36, 'Spicy Ketchup',        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80',  35, 1),
-- Item 37: Nachos
(85,37, 'Corn Tortilla Chips',  'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=300&q=80', 150, 1),
(86,37, 'Seasoned Ground Beef', 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300&q=80', 120, 1),
(87,37, 'Melted Queso Cheese',  'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?w=300&q=80',  80, 1),
(88,37, 'Sliced Jalapeños',     'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80',  25, 1),
-- Item 38: Chicken Wings
(89,38, 'Fresh Chicken Wings',  'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=300&q=80', 280, 1),
(90,38, 'Garlic Parmesan Mix',  'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=300&q=80',  40, 1),
(91,38, 'Ranch Dip',            'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',  35, 1);

-- ============================================================
--  TABLE: favorites
-- ============================================================
CREATE TABLE `favorites` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `menu_item_id` INT UNSIGNED  NOT NULL,
  `created_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_favorite` (`user_id`, `menu_item_id`),
  CONSTRAINT `fk_fav_user` FOREIGN KEY (`user_id`)      REFERENCES `users`      (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fav_menu` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  TABLE: cart_items
-- ============================================================
CREATE TABLE `cart_items` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `menu_item_id` INT UNSIGNED  NOT NULL,
  `color`        VARCHAR(50)   DEFAULT NULL,
  `size`         VARCHAR(20)   DEFAULT NULL,
  `quantity`     INT           NOT NULL DEFAULT 1,
  `created_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`)      REFERENCES `users`      (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_menu` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  TABLE: addresses
-- ============================================================
CREATE TABLE `addresses` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `label`        VARCHAR(100)  NOT NULL DEFAULT 'Home',
  `full_address` TEXT          NOT NULL,
  `lat`          DECIMAL(10,7) DEFAULT NULL,
  `lng`          DECIMAL(10,7) DEFAULT NULL,
  `is_default`   TINYINT(1)    NOT NULL DEFAULT 0,
  `created_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_addr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  TABLE: orders
-- ============================================================
CREATE TABLE `orders` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `address_id`   INT UNSIGNED  DEFAULT NULL,
  `status`       VARCHAR(50)   NOT NULL DEFAULT 'pending',
  `subtotal`     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `delivery_fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `total`        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `created_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_orders_user`    FOREIGN KEY (`user_id`)    REFERENCES `users`     (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orders_address` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  TABLE: order_items
-- ============================================================
CREATE TABLE `order_items` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `order_id`     INT UNSIGNED  NOT NULL,
  `menu_item_id` INT UNSIGNED  NOT NULL,
  `quantity`     INT           NOT NULL DEFAULT 1,
  `price`        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `color`        VARCHAR(50)   DEFAULT NULL,
  `size`         VARCHAR(20)   DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`)     REFERENCES `orders`     (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_oi_menu`  FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── Re-enable FK checks ──────────────────────────────────────
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- ============================================================
--  SUMMARY
--  ✅  3 demo users        (all password: password123)
--  ✅  6 food categories   (Breakfast · Lunch · Dinner · Dessert · Drinks · Snacks)
--  ✅  4 promo banners
--  ✅  42 menu items       (7 Breakfast · 7 Lunch · 7 Dinner · 7 Dessert · 7 Drinks · 7 Snacks)
--  ✅  91 ingredient rows
--  ✅  All FK constraints set
-- ============================================================