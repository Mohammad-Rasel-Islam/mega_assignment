-- ============================================================
--  shop_app_db.sql
--  Import this file in phpMyAdmin to set up the database.
--  Steps:
--    1. Open phpMyAdmin: http://localhost/phpmyadmin
--    2. Click "New" on left sidebar, create DB: shop_app_db (utf8mb4_unicode_ci)
--    3. Select that database -> click "Import" -> choose this file -> Go
-- ============================================================

CREATE DATABASE IF NOT EXISTS `shop_app_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `shop_app_db`;

-- ─────────────────────────────────────────────────────────────
--  USERS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `users` (
  `id`             INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(100)    NOT NULL,
  `email`          VARCHAR(150)    NOT NULL UNIQUE,
  `password`       VARCHAR(255)    NOT NULL,
  `remember_token` VARCHAR(100)    DEFAULT NULL,
  `photo_url`      VARCHAR(500)    DEFAULT NULL,
  `created_at`     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Demo user: email=demo@shop.com  password=password123
INSERT INTO `users` (`name`, `email`, `password`) VALUES
('Demo User', 'demo@shop.com', '$2y$10$zgqDoNcrszs8O7.Db99SfOZQhs0abRNqZQBKxYHu1wCe9itLsgX7W');

-- ─────────────────────────────────────────────────────────────
--  CATEGORIES
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `categories` (
  `id`        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `name`      VARCHAR(100)  NOT NULL,
  `icon`      VARCHAR(100)  DEFAULT NULL,
  `image_url` VARCHAR(500)  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `categories` (`id`, `name`, `icon`, `image_url`) VALUES
(1, 'Fashion', '👗', 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&q=80'),
(2, 'Electronics', '📱', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400&q=80'),
(3, 'Smartphones', '📲', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&q=80'),
(4, 'Laptops & PCs', '💻', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&q=80'),
(5, 'Audio & Sound', '🎧', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80'),
(6, 'Wearables', '⌚', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80'),
(7, 'Gaming & VR', '🎮', 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=400&q=80'),
(8, 'Cameras & Drones', '📷', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&q=80'),
(9, 'Smart Home', '🏠', 'https://images.unsplash.com/photo-1558002038-1055907df827?w=400&q=80'),
(10, 'Accessories', '⌨️', 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=400&q=80'),
(11, 'Beauty', '💄', 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&q=80'),
(12, 'Sports', '⚽', 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400&q=80'),
(13, 'Food', '🍕', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80');

-- ─────────────────────────────────────────────────────────────
--  PRODUCTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `products` (
  `id`          INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  `category_id` INT UNSIGNED    NOT NULL,
  `name`        VARCHAR(200)    NOT NULL,
  `description` TEXT            DEFAULT NULL,
  `price`       DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  `rating`      DECIMAL(3,1)    NOT NULL DEFAULT 0.0,
  `is_popular`  TINYINT(1)      NOT NULL DEFAULT 0,
  `colors`      JSON            DEFAULT NULL,
  `sizes`       JSON            DEFAULT NULL,
  `created_at`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_products_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `price`, `rating`, `is_popular`, `colors`, `sizes`) VALUES
(1, 1, 'Classic White Sneakers', 'Timeless white sneakers with premium leather upper and cushioned sole. Perfect for everyday wear.', 79.99, 4.5, 1, '["#FFFFFF","#000000","#8B4513"]', '["38","39","40","41","42","43","44"]'),
(2, 1, 'Slim Fit Denim Jeans', 'Modern slim-fit jeans crafted from high-quality stretch denim for all-day comfort.', 59.99, 4.3, 1, '["#1E3A5F","#000000","#6B4C3B"]', '["XS","S","M","L","XL","XXL"]'),
(3, 1, 'Floral Summer Dress', 'Light and airy floral dress perfect for warm days. Features a flattering A-line silhouette.', 49.99, 4.7, 1, '["#FF6B9D","#FFF9C4","#E8F5E9"]', '["XS","S","M","L","XL"]'),
(4, 1, 'Leather Crossbody Bag', 'Genuine leather crossbody bag with multiple compartments. Elegant and functional.', 129.99, 4.6, 0, '["#8B4513","#000000","#D2691E"]', '["One Size"]'),
(5, 5, 'Wireless Noise-Cancelling Headphones', 'Premium over-ear headphones with active noise cancellation, 30-hour battery life, and superior sound quality.', 199.99, 4.8, 1, '["#000000","#C0C0C0","#003366"]', '["One Size"]'),
(6, 6, 'Smart Watch Pro', 'Feature-packed smartwatch with health monitoring, GPS, and a stunning AMOLED display.', 249.99, 4.6, 1, '["#000000","#C0C0C0","#FF6B35"]', '["38mm","42mm","45mm"]'),
(7, 5, 'Portable Bluetooth Speaker', 'Waterproof portable speaker with 360-degree surround sound and 20-hour playtime.', 89.99, 4.4, 0, '["#000000","#FF6B35","#1E90FF"]', '["One Size"]'),
(8, 10, 'Wireless Charging Pad', 'Fast-charging Qi wireless pad compatible with all Qi-enabled devices. Sleek and minimal design.', 34.99, 4.2, 0, '["#000000","#FFFFFF"]', '["One Size"]'),
(9, 11, 'Vitamin C Brightening Serum', 'Powerful antioxidant serum with 20% Vitamin C that visibly brightens and evens skin tone.', 45.99, 4.7, 1, '["#FFD700"]', '["30ml","50ml"]'),
(10, 11, 'Matte Lipstick Collection', 'Long-lasting matte lipstick in rich, vibrant shades. Moisturising formula that wears all day.', 19.99, 4.5, 1, '["#C0392B","#E91E8C","#8B008B","#FF6347","#CD853F"]', '["One Size"]'),
(11, 12, 'Pro Running Shoes', 'Engineered for performance with responsive foam midsole and breathable mesh upper.', 139.99, 4.6, 1, '["#000000","#FF6B35","#1E90FF","#FFFFFF"]', '["38","39","40","41","42","43","44","45"]'),
(12, 12, 'Yoga Mat Premium', 'Extra-thick 6mm eco-friendly yoga mat with non-slip surface and alignment lines.', 39.99, 4.4, 0, '["#9C27B0","#2196F3","#4CAF50","#FF9800"]', '["Standard","Extra Long"]'),
(13, 13, 'Organic Green Tea Pack', 'Premium ceremonial-grade organic green tea sourced from Japanese farms. Rich in antioxidants.', 24.99, 4.8, 1, '["#4CAF50"]', '["50g","100g","200g"]'),
(14, 13, 'Dark Chocolate Gift Box', 'Artisan dark chocolate collection with 70% cacao. An indulgent treat for chocolate lovers.', 34.99, 4.9, 1, '["#3E2723"]', '["12 pcs","24 pcs"]'),
(15, 3, 'iPhone 15 Pro Max', 'Titanium design, A17 Pro chip with 6-core GPU, customizable Action button, and 5x Telephoto camera system.', 1199.99, 4.9, 1, '["#3C3B37","#F2F1ED","#2A323D","#53524E"]', '["256GB","512GB","1TB"]'),
(16, 3, 'Samsung Galaxy S24 Ultra', 'Galaxy AI integration, Snapdragon 8 Gen 3, built-in S Pen, and 200MP camera with Quad Tele System.', 1299.99, 4.8, 1, '["#1C1C1C","#A49B8E","#E4D9C7","#4B4666"]', '["256GB","512GB","1TB"]'),
(17, 3, 'Google Pixel 8 Pro', 'Google Tensor G3 processor, advanced AI photo features, pro camera controls, and 6.7-inch Super Actua display.', 999.99, 4.7, 1, '["#1B1B1B","#A0B2C6","#F7F4EF"]', '["128GB","256GB","512GB"]'),
(18, 3, 'OnePlus 12 5G', 'Snapdragon 8 Gen 3, 4th Gen Hasselblad Camera for Mobile, 100W SUPERVOOC charging, and 2K 120Hz display.', 799.99, 4.6, 0, '["#0B3C26","#1A1A1A"]', '["256GB","512GB"]'),
(19, 3, 'Xiaomi 14 Ultra', 'Leica Quad Camera system, 1-inch main sensor, Snapdragon 8 Gen 3, and 120Hz WQHD+ AMOLED display.', 1099.99, 4.7, 0, '["#000000","#FFFFFF"]', '["512GB"]'),
(20, 3, 'Samsung Galaxy Z Fold 5', 'Immersive 7.6-inch main foldable screen, redesigned Flex Hinge, multitasking taskbar, and Snapdragon 8 Gen 2.', 1799.99, 4.6, 1, '["#292F36","#ECECEC","#B3C5D7"]', '["256GB","512GB","1TB"]'),
(21, 3, 'Samsung Galaxy Z Flip 5', '3.4-inch Flex Window cover screen, pocket-sized foldable design, hands-free FlexCam photography.', 999.99, 4.5, 0, '["#D4E2D4","#FAF0E6","#4A4E69","#D0B8AC"]', '["256GB","512GB"]'),
(22, 3, 'ASUS ROG Phone 8 Pro', 'Ultimate gaming phone powered by Snapdragon 8 Gen 3, AniMe Vision LED display back, AirTrigger controls, and 165Hz screen.', 1199.99, 4.8, 0, '["#111111"]', '["512GB","1TB"]'),
(23, 4, 'MacBook Pro 16-inch M3 Max', 'Liquid Retina XDR display, up to 128GB unified memory, 22 hours battery life, HDMI, SD card reader, Thunderbolt 4 ports.', 2499.99, 4.9, 1, '["#2E2E2E","#C0C0C0"]', '["512GB SSD","1TB SSD","2TB SSD"]'),
(24, 4, 'MacBook Air 15-inch M3', 'Strikingly thin design, M3 chip speed, Liquid Retina display, 18-hour battery, silent fanless design.', 1299.99, 4.8, 1, '["#19232D","#F0E6D2","#D1D5DB","#8E8E93"]', '["256GB SSD","512GB SSD"]'),
(25, 4, 'Dell XPS 16 Laptop', 'Intel Core Ultra 9 processor, NVIDIA GeForce RTX 4070, 4K+ OLED touch screen, sleek machined aluminum chassis.', 2199.99, 4.7, 1, '["#000000","#DCDCDC"]', '["1TB SSD","2TB SSD"]'),
(26, 4, 'Lenovo ThinkPad X1 Carbon Gen 12', 'Ultralight carbon-fiber laptop with Intel Evo platform, legendary Keyboard, OLED display option, and enterprise security.', 1849.99, 4.7, 0, '["#1A1A1A"]', '["512GB SSD","1TB SSD"]'),
(27, 4, 'ASUS ROG Zephyrus G16 Gaming Laptop', 'Ultra-slim gaming laptop with Intel Core Ultra 9, RTX 4080 GPU, 240Hz OLED ROG Nebula display.', 1999.99, 4.8, 1, '["#111111","#E0E0E0"]', '["1TB SSD","2TB SSD"]'),
(28, 4, 'HP Spectre x360 14 2-in-1', 'Convertible laptop with 2.8K OLED touchscreen, Intel Core Ultra 7, included Stylus Pen, and Poly Studio quad speakers.', 1449.99, 4.6, 0, '["#1E222A","#2C3539"]', '["512GB SSD","1TB SSD"]'),
(29, 4, 'Razer Blade 16 Gaming Laptop', 'Dual-mode Mini-LED display (4K 120Hz / FHD+ 240Hz), Intel i9 14900HX, RTX 4090 GPU, CNC aluminum unibody.', 3099.99, 4.9, 1, '["#000000"]', '["1TB SSD","2TB SSD"]'),
(30, 4, 'Microsoft Surface Laptop Studio 2', 'Dynamic woven hinge transitions seamlessly from laptop to angled stage to portable studio canvas. RTX 4060 powered.', 1999.99, 4.5, 0, '["#C0C0C0"]', '["512GB SSD","1TB SSD"]'),
(31, 2, 'iPad Pro 13-inch M4', 'Ultra Retina XDR Tandem OLED display, incredibly thin 5.1mm body, M4 chip performance, supports Apple Pencil Pro.', 1299.99, 4.9, 1, '["#1D1D1F","#E3E4E6"]', '["256GB","512GB","1TB"]'),
(32, 2, 'Samsung Galaxy Tab S9 Ultra', 'Massive 14.6-inch Dynamic AMOLED 2X screen, IP68 water & dust resistance, bundled S Pen, Snapdragon 8 Gen 2.', 1199.99, 4.8, 1, '["#232B32","#E6E6E6"]', '["256GB","512GB"]'),
(33, 2, 'iPad Air 11-inch M2', 'Supercharged by M2 chip, Liquid Retina display, landscape front camera, Touch ID in top button, 5G cellular options.', 599.99, 4.7, 1, '["#2D3748","#3182CE","#805AD5","#E2E8F0"]', '["128GB","256GB","512GB"]'),
(34, 2, 'Kindle Scribe E-Reader', '10.2-inch 300 ppi glare-free Paperwhite display, included Premium Pen for note-taking, reading, and digital journaling.', 339.99, 4.6, 0, '["#2F3640"]', '["16GB","32GB","64GB"]'),
(35, 5, 'Sony WH-1000XM5 Wireless Headphones', 'Industry-leading noise cancellation with 8 microphones, Auto NC Optimizer, 30-hour battery, precise voice pickup.', 399.99, 4.9, 1, '["#000000","#E6E2DD","#1E2836"]', '["One Size"]'),
(36, 5, 'Apple AirPods Pro (2nd Gen, USB-C)', 'Active Noise Cancellation up to 2x more, Adaptive Audio, Transparency mode, Personalized Spatial Audio, MagSafe USB-C case.', 249.99, 4.8, 1, '["#FFFFFF"]', '["Standard"]'),
(37, 5, 'Bose QuietComfort Ultra Headphones', 'Breakthrough spatialized audio for more immersive listening, world-class noise cancellation, CustomTune technology.', 429.99, 4.7, 1, '["#000000","#D5CFCE","#2C3E50"]', '["One Size"]'),
(38, 5, 'Sennheiser Momentum 4 Wireless', 'Audiophile-grade 42mm transducer system, custom sound EQ, unmatched 60-hour battery life, adaptive ANC.', 349.99, 4.6, 0, '["#000000","#FFFFFF"]', '["One Size"]'),
(39, 5, 'Sonos Move 2 Portable Speaker', 'Weatherproof battery-powered speaker delivering stereo sound indoors and out, 24-hour battery, Wi-Fi & Bluetooth.', 449.99, 4.8, 1, '["#000000","#FFFFFF","#5B7065"]', '["Portable"]'),
(40, 5, 'JBL Flip 6 Bluetooth Speaker', 'IP67 waterproof and dustproof portable Bluetooth speaker, 2-way speaker system, 12 hours playtime, PartyBoost pairing.', 129.99, 4.6, 0, '["#000000","#D32F2F","#1976D2","#388E3C"]', '["Compact"]'),
(41, 5, 'Marshall Stanmore III Bluetooth Speaker', 'Iconic vintage home speaker with wider soundstage, Bluetooth 5.2, signature Marshall brass controls, rich bass.', 379.99, 4.7, 0, '["#000000","#F5F5DC","#4A3525"]', '["Home Size"]'),
(42, 5, 'Beats Studio Pro Wireless Headphones', 'Custom acoustic platform, lossless audio via USB-C, fully adaptive Active Noise Cancelling, up to 40 hours battery.', 349.99, 4.5, 0, '["#000000","#5E503F","#3D405B","#A8A29E"]', '["One Size"]'),
(43, 6, 'Apple Watch Ultra 2', '49mm titanium case, brightest 3000-nit display, precision dual-frequency GPS, 36-hour battery life, 100m water resistance.', 799.99, 4.9, 1, '["#D4D4D8"]', '["49mm"]'),
(44, 6, 'Apple Watch Series 9', 'S9 SiP chip, double tap gesture control, brighter display, fast charging, ECG and blood oxygen sensing.', 399.99, 4.8, 1, '["#000000","#F5E6E8","#E2E8F0","#C0392B"]', '["41mm","45mm"]'),
(45, 6, 'Samsung Galaxy Watch 6 Classic', 'Iconic rotating bezel, advanced sleep coaching, BIA body composition sensor, sapphire crystal glass display.', 399.99, 4.6, 1, '["#000000","#C0C0C0"]', '["43mm","47mm"]'),
(46, 6, 'Garmin Fenix 7 Pro Sapphire Solar', 'Multisport GPS smartwatch with built-in LED flashlight, solar charging lens, topo maps, and up to 37 days battery.', 899.99, 4.9, 1, '["#1E1E1E","#4A4A4A"]', '["42mm","47mm","51mm"]'),
(47, 6, 'Garmin Forerunner 965', 'Premium triathlon & running smartwatch with vibrant AMOLED display, titanium bezel, multi-band GPS, training readiness.', 599.99, 4.8, 0, '["#000000","#FFD700","#FFFFFF"]', '["47mm"]'),
(48, 6, 'Oura Ring Gen3 Horizon', 'Sleek titanium smart ring tracking sleep stages, readiness score, heart rate variability, body temperature, and cycle insights.', 349.99, 4.6, 1, '["#000000","#C0C0C0","#FFD700","#4A4A4A"]', '["US 6","US 7","US 8","US 9","US 10","US 11","US 12"]'),
(49, 6, 'Fitbit Charge 6 Fitness Tracker', 'Advanced fitness tracker with Google Built-In Apps (Maps, Wallet), 40+ exercise modes, built-in GPS, 7-day battery.', 159.99, 4.4, 0, '["#000000","#FAEDCD","#E0E1DD"]', '["S/L Combo"]'),
(50, 7, 'PlayStation 5 Slim Digital Edition', 'Next-gen console with 1TB SSD storage, ultra-high speed SSD, DualSense wireless controller haptic feedback, 4K 120Hz gaming.', 449.99, 4.9, 1, '["#FFFFFF"]', '["1TB SSD"]'),
(51, 7, 'Xbox Series X Console', '12 teraflops of raw graphic processing power, 4K gaming at up to 120 FPS, 1TB custom NVMe SSD, Velocity Architecture.', 499.99, 4.8, 1, '["#000000"]', '["1TB SSD"]'),
(52, 7, 'Nintendo Switch OLED Model', 'Vibrant 7-inch OLED screen, wide adjustable stand, wired LAN port dock, 64GB storage, handheld & TV modes.', 349.99, 4.8, 1, '["#FFFFFF","#000000","#FF0000"]', '["64GB"]'),
(53, 7, 'Meta Quest 3 VR Headset', 'Breakthrough mixed reality VR headset, 4K+ Infinite Display resolution, Touch Plus controllers, Snapdragon XR2 Gen 2.', 499.99, 4.7, 1, '["#FFFFFF"]', '["128GB","512GB"]'),
(54, 7, 'Steam Deck OLED Handheld Console', '7.4-inch HDR OLED display, custom AMD APU, 90Hz refresh rate, Wi-Fi 6E, ergonomic controls, runs PC Steam library.', 549.99, 4.9, 1, '["#000000"]', '["512GB NVMe","1TB NVMe"]'),
(55, 8, 'Sony Alpha 7 IV Mirrorless Camera', '33MP full-frame Exmor R CMOS sensor, 4K 60p video, real-time eye AF for humans/animals/birds, 5-axis body stabilization.', 2498.99, 4.9, 1, '["#000000"]', '["Body Only","With 28-70mm Lens"]'),
(56, 8, 'Canon EOS R6 Mark II Camera', '24.2MP full-frame CMOS sensor, 40 fps high-speed shooting, 4K 60p uncropped video, Dual Pixel CMOS AF II.', 2299.99, 4.8, 1, '["#000000"]', '["Body Only","With 24-105mm Lens"]'),
(57, 8, 'DJI Mini 4 Pro Drone', 'Lightweight under 249g foldable drone, 4K/60fps HDR true vertical shooting, omnidirectional obstacle sensing, 34-min flight.', 759.99, 4.9, 1, '["#D4D4D8"]', '["Standard Remote","RC 2 Screen Controller"]'),
(58, 8, 'GoPro HERO12 Black Action Camera', '5.3K60 & 4K120 video resolution, HyperSmooth 6.0 video stabilization, dual LCD screens, waterproof down to 33ft.', 399.99, 4.7, 1, '["#000000"]', '["Standard Bundle"]'),
(59, 8, 'Fujifilm X100VI Digital Camera', '40.2MP APS-C X-Trans CMOS 5 HR sensor, 23mm F2 fixed lens, in-body image stabilization, iconic film simulation modes.', 1599.99, 4.9, 1, '["#000000","#C0C0C0"]', '["Fixed Lens"]'),
(60, 8, 'DJI Osmo Pocket 3 Camera', 'Powerful 1-inch CMOS sensor pocket camera, 2-inch rotatable touchscreen, 4K/120fps mechanical 3-axis stabilization.', 519.99, 4.8, 1, '["#000000"]', '["Standard Combo","Creator Combo"]'),
(61, 9, 'Philips Hue Smart Bridge & Color Kit', '4 Smart A19 LED bulbs + Hue Bridge. 16 million colors, voice control with Alexa/Google Home/Apple HomeKit.', 199.99, 4.7, 0, '["#FFFFFF"]', '["Starter Kit"]'),
(62, 9, 'Nest Learning Thermostat (3rd Gen)', 'Energy-saving smart thermostat that learns your schedule, controls remotely via smartphone, and auto-adjusts when away.', 249.99, 4.6, 0, '["#C0C0C0","#000000","#B8860B","#FFFFFF"]', '["Standard"]'),
(63, 9, 'Ring Video Doorbell Pro 2', '1536p HD Head-to-Toe Video, 3D Motion Detection with Bird’s Eye View, Alexa Greetings, hardwired installation.', 229.99, 4.5, 0, '["#C0C0C0","#000000"]', '["Standard"]'),
(64, 9, 'Amazon Echo Show 10 (3rd Gen)', '10.1-inch HD smart display with motion that automatically turns to face you, 13MP camera, premium directional sound.', 249.99, 4.6, 1, '["#000000","#FFFFFF"]', '["10.1 inch"]'),
(65, 10, 'Logitech MX Master 3S Wireless Mouse', 'Quiet Clicks performance mouse, 8K DPI laser tracking on any surface, MagSpeed electromagnetic scrolling wheel.', 99.99, 4.9, 1, '["#2D3142","#E5E5E5"]', '["Standard"]'),
(66, 10, 'Keychron Q1 Pro Wireless Mechanical Keyboard', 'QMK/VIA programmable custom mechanical keyboard, full aluminum body, hot-swappable switches, double-gasket design.', 199.99, 4.8, 1, '["#1E1E1E","#D3D3D3","#003366"]', '["75% Layout"]'),
(67, 10, 'Samsung Odyssey OLED G9 Gaming Monitor', '49-inch dual QHD curved OLED display, 240Hz refresh rate, 0.03ms response time, Neo Quantum Processor Pro.', 1599.99, 4.9, 1, '["#C0C0C0","#000000"]', '["49-inch Curved"]'),
(68, 10, 'Anker 737 Power Bank (PowerCore 24K)', '24,000mAh capacity, ultra-powerful 140W bi-directional fast charging, smart digital display showing battery & output.', 149.99, 4.8, 1, '["#000000"]', '["24,000mAh"]'),
(69, 10, 'Elgato Stream Deck MK.2', 'Studio controller with 15 customizable LCD keys for broadcasting, video editing, audio mixing, and smart home automation.', 149.99, 4.8, 0, '["#000000","#FFFFFF"]', '["15 Keys"]'),
(70, 10, 'CalDigit TS4 Thunderbolt 4 Dock', '18 ports of extreme connectivity including 98W laptop charging, dual 4K / single 8K monitor support, 2.5Gb Ethernet.', 399.99, 4.7, 0, '["#C0C0C0"]', '["18 Ports"]'),
(71, 10, 'Belkin BoostCharge Pro 3-in-1 MagSafe', 'Fast wireless charging stand for iPhone 15/14, Apple Watch Ultra/Series 9, and AirPods, 15W MagSafe alignment.', 149.99, 4.7, 1, '["#000000","#FFFFFF"]', '["3-in-1"]'),
(72, 10, 'SanDisk 2TB Extreme Portable SSD', 'Rugged external SSD with NVMe solid state performance featuring 1050MB/s read speeds, IP55 water & dust resistance.', 169.99, 4.8, 1, '["#000000","#1E3A5F"]', '["1TB","2TB","4TB"]'),
(73, 10, 'ASUS ROG Swift PG32UCDM OLED Monitor', '32-inch 4K QD-OLED gaming monitor with 240Hz refresh rate, 0.03ms response time, custom heatsink for burn-in prevention.', 1299.99, 4.9, 1, '["#000000"]', '["32-inch 4K"]'),
(74, 10, 'Shure SM7B Cardioid Dynamic Microphone', 'Legendary studio vocal microphone delivering clean, warm and smooth vocal reproduction for podcasting and streaming.', 399.99, 4.9, 1, '["#000000"]', '["XLR"]'),
(75, 10, 'Nanoleaf Shapes Triangles Starter Kit', 'Modular LED light panels with RGB animation, music visualizer sync, touch interactions, and smart home control.', 199.99, 4.6, 0, '["#FFFFFF"]', '["7 Panels"]');

-- ─────────────────────────────────────────────────────────────
--  PRODUCT IMAGES
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `product_images` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED  NOT NULL,
  `image_url`  VARCHAR(500)  NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_images_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `product_images` (`id`, `product_id`, `image_url`) VALUES
(1, 1, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80'),
(2, 1, 'https://images.unsplash.com/photo-1600185365778-8e80b87b7b0c?w=600&q=80'),
(3, 2, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&q=80'),
(4, 2, 'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=600&q=80'),
(5, 3, 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600&q=80'),
(6, 3, 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600&q=80'),
(7, 4, 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&q=80'),
(8, 5, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80'),
(9, 5, 'https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=600&q=80'),
(10, 6, 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80'),
(11, 6, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80'),
(12, 7, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600&q=80'),
(13, 8, 'https://images.unsplash.com/photo-1615526675159-e248c3021d3f?w=600&q=80'),
(14, 9, 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=600&q=80'),
(15, 9, 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab12?w=600&q=80'),
(16, 10, 'https://images.unsplash.com/photo-1586495777744-4e6232bf4553?w=600&q=80'),
(17, 10, 'https://images.unsplash.com/photo-1512207736890-6ffed8a84e8d?w=600&q=80'),
(18, 11, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80'),
(19, 11, 'https://images.unsplash.com/photo-1605348532760-6753d2c43329?w=600&q=80'),
(20, 12, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600&q=80'),
(21, 13, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&q=80'),
(22, 13, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=600&q=80'),
(23, 14, 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=600&q=80'),
(24, 14, 'https://images.unsplash.com/photo-1606312619070-d48b7c7c64f5?w=600&q=80'),
(25, 15, 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&q=80'),
(26, 15, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600&q=80'),
(27, 16, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=600&q=80'),
(28, 16, 'https://images.unsplash.com/photo-1583573636246-18cb2246697f?w=600&q=80'),
(29, 17, 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600&q=80'),
(30, 17, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80'),
(31, 18, 'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=600&q=80'),
(32, 18, 'https://images.unsplash.com/photo-1574944985070-8f30c4397e3c?w=600&q=80'),
(33, 19, 'https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?w=600&q=80'),
(34, 19, 'https://images.unsplash.com/photo-1546054454-aa26e2b734c7?w=600&q=80'),
(35, 20, 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=600&q=80'),
(36, 20, 'https://images.unsplash.com/photo-1616469829941-c7200edec809?w=600&q=80'),
(37, 21, 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=600&q=80'),
(38, 21, 'https://images.unsplash.com/photo-1533228876829-65c94e7b5025?w=600&q=80'),
(39, 22, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=80'),
(40, 22, 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&q=80'),
(41, 23, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80'),
(42, 23, 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=600&q=80'),
(43, 24, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=600&q=80'),
(44, 24, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600&q=80'),
(45, 25, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600&q=80'),
(46, 25, 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=600&q=80'),
(47, 26, 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=600&q=80'),
(48, 26, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80'),
(49, 27, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600&q=80'),
(50, 27, 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=600&q=80'),
(51, 28, 'https://images.unsplash.com/photo-1544731612-de7f96afe55f?w=600&q=80'),
(52, 28, 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=600&q=80'),
(53, 29, 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=600&q=80'),
(54, 29, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=80'),
(55, 30, 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=600&q=80'),
(56, 30, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600&q=80'),
(57, 31, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&q=80'),
(58, 31, 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=600&q=80'),
(59, 32, 'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=600&q=80'),
(60, 32, 'https://images.unsplash.com/photo-1542751110-97427bbecf20?w=600&q=80'),
(61, 33, 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=600&q=80'),
(62, 33, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&q=80'),
(63, 34, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80'),
(64, 34, 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=600&q=80'),
(65, 35, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80'),
(66, 35, 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=600&q=80'),
(67, 36, 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600&q=80'),
(68, 36, 'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=600&q=80'),
(69, 37, 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600&q=80'),
(70, 37, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80'),
(71, 38, 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&q=80'),
(72, 38, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=80'),
(73, 39, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600&q=80'),
(74, 39, 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=600&q=80'),
(75, 40, 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=600&q=80'),
(76, 40, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600&q=80'),
(77, 41, 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=600&q=80'),
(78, 41, 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=600&q=80'),
(79, 42, 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&q=80'),
(80, 42, 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600&q=80'),
(81, 43, 'https://images.unsplash.com/photo-1510017803434-a899398421b3?w=600&q=80'),
(82, 43, 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&q=80'),
(83, 44, 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80'),
(84, 44, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80'),
(85, 45, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80'),
(86, 45, 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&q=80'),
(87, 46, 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&q=80'),
(88, 46, 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80'),
(89, 47, 'https://images.unsplash.com/photo-1510017803434-a899398421b3?w=600&q=80'),
(90, 47, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80'),
(91, 48, 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&q=80'),
(92, 48, 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600&q=80'),
(93, 49, 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=600&q=80'),
(94, 49, 'https://images.unsplash.com/photo-1510017803434-a899398421b3?w=600&q=80'),
(95, 50, 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=600&q=80'),
(96, 50, 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&q=80'),
(97, 51, 'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?w=600&q=80'),
(98, 51, 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=600&q=80'),
(99, 52, 'https://images.unsplash.com/photo-1578303512597-81e6cc155b3e?w=600&q=80'),
(100, 52, 'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=600&q=80'),
(101, 53, 'https://images.unsplash.com/photo-1622979135225-d2ba269bc1bd?w=600&q=80'),
(102, 53, 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=600&q=80'),
(103, 54, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=80'),
(104, 54, 'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=600&q=80'),
(105, 55, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80'),
(106, 55, 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=600&q=80'),
(107, 56, 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=600&q=80'),
(108, 56, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80'),
(109, 57, 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=600&q=80'),
(110, 57, 'https://images.unsplash.com/photo-1473968512647-3e447244af8f?w=600&q=80'),
(111, 58, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&q=80'),
(112, 58, 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=600&q=80'),
(113, 59, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80'),
(114, 59, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&q=80'),
(115, 60, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&q=80'),
(116, 60, 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=600&q=80'),
(117, 61, 'https://images.unsplash.com/photo-1550985616-10810253b84d?w=600&q=80'),
(118, 61, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80'),
(119, 62, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80'),
(120, 62, 'https://images.unsplash.com/photo-1550985616-10810253b84d?w=600&q=80'),
(121, 63, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80'),
(122, 63, 'https://images.unsplash.com/photo-1550985616-10810253b84d?w=600&q=80'),
(123, 64, 'https://images.unsplash.com/photo-1543512214-318c7553f230?w=600&q=80'),
(124, 64, 'https://images.unsplash.com/photo-1512446816042-444d641267d4?w=600&q=80'),
(125, 65, 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&q=80'),
(126, 65, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600&q=80'),
(127, 66, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=80'),
(128, 66, 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=600&q=80'),
(129, 67, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&q=80'),
(130, 67, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600&q=80'),
(131, 68, 'https://images.unsplash.com/photo-1609592424074-9f893e4334a1?w=600&q=80'),
(132, 68, 'https://images.unsplash.com/photo-1615526675159-e248c3021d3f?w=600&q=80'),
(133, 69, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=80'),
(134, 69, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=80'),
(135, 70, 'https://images.unsplash.com/photo-1544731612-de7f96afe55f?w=600&q=80'),
(136, 70, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600&q=80'),
(137, 71, 'https://images.unsplash.com/photo-1615526675159-e248c3021d3f?w=600&q=80'),
(138, 71, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600&q=80'),
(139, 72, 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=600&q=80'),
(140, 72, 'https://images.unsplash.com/photo-1544731612-de7f96afe55f?w=600&q=80'),
(141, 73, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&q=80'),
(142, 73, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600&q=80'),
(143, 74, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=80'),
(144, 74, 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&q=80'),
(145, 75, 'https://images.unsplash.com/photo-1550985616-10810253b84d?w=600&q=80'),
(146, 75, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80');

-- ─────────────────────────────────────────────────────────────
--  CART ITEMS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `cart_items` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`    INT UNSIGNED  NOT NULL,
  `product_id` INT UNSIGNED  NOT NULL,
  `color`      VARCHAR(50)   DEFAULT NULL,
  `size`       VARCHAR(20)   DEFAULT NULL,
  `quantity`   INT           NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_cart_user`    (`user_id`),
  KEY `fk_cart_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─────────────────────────────────────────────────────────────
--  WISHLISTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `wishlists` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`    INT UNSIGNED  NOT NULL,
  `product_id` INT UNSIGNED  NOT NULL,
  `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wishlist` (`user_id`, `product_id`),
  KEY `fk_wishlist_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─────────────────────────────────────────────────────────────
--  ADDRESSES
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `addresses` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `label`        VARCHAR(100)  NOT NULL DEFAULT 'Home',
  `full_address` TEXT          NOT NULL,
  `lat`          DECIMAL(10,7) DEFAULT NULL,
  `lng`          DECIMAL(10,7) DEFAULT NULL,
  `is_default`   TINYINT(1)   NOT NULL DEFAULT 0,
  `created_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_addresses_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─────────────────────────────────────────────────────────────
--  ORDERS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `orders` (
  `id`           INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED    NOT NULL,
  `address_id`   INT UNSIGNED    DEFAULT NULL,
  `status`       VARCHAR(50)     NOT NULL DEFAULT 'pending',
  `subtotal`     DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  `delivery_fee` DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  `total`        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  `created_at`   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_orders_user`    (`user_id`),
  KEY `fk_orders_address` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─────────────────────────────────────────────────────────────
--  ORDER ITEMS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `order_items` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `order_id`   INT UNSIGNED  NOT NULL,
  `product_id` INT UNSIGNED  NOT NULL,
  `quantity`   INT           NOT NULL DEFAULT 1,
  `price`      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `color`      VARCHAR(50)   DEFAULT NULL,
  `size`       VARCHAR(20)   DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_items_order`   (`order_id`),
  KEY `fk_items_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;