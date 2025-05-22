-- Sample Guest Accounts
INSERT INTO guest_accounts (contact_number) VALUES
('09171234567'), ('09179876543'), ('09172345678');

-- Insert Sample Images
INSERT INTO Image_List (Image) VALUES
(0x00), (0x00), (0x00); -- Dummy binary data for simplicity

-- Sample Food (Normal Items) - Required for Items
INSERT INTO Food_List (Food_Name, Availability) VALUES
('Fried Chicken', TRUE),
('Spaghetti', TRUE),
('Burger Steak', TRUE);

-- Sample Category
INSERT INTO Food_Category (Category_Name) VALUES ('Main Course');

-- Sample Normal Food Entries
INSERT INTO Normal_Food_List (Food_ID, F_Category_ID, Image_ID, Description, Price, Code_Name) VALUES
(1, 1, 1, 'Delicious fried chicken', 120.00, 'FRCHICK'),
(2, 1, 2, 'Sweet spaghetti with meat', 95.00, 'SPAGMEAT'),
(3, 1, 3, 'Burger patty with rice and gravy', 105.00, 'BURGSTEAK');

-- Dine-In Order
INSERT INTO processing_orders (
    order_status, guest_id, guest_name, guest_location, transaction_id, order_list_id,
    delivery_payment_status, gcash_ref, table_number, order_type
) VALUES (
    'Pending', 1, 'Juan Dela Cruz', NULL, 10001, 5001, 'No', NULL, 7, 'dine-in'
);

-- Take-Out Order
INSERT INTO processing_orders (
    order_status, guest_id, guest_name, guest_location, transaction_id, order_list_id,
    delivery_payment_status, gcash_ref, table_number, order_type
) VALUES (
    'Pending', 2, 'Maria Santos', NULL, 10002, 5002, 'No', NULL, NULL, 'take-out'
);

-- Delivery Order
INSERT INTO processing_orders (
    order_status, guest_id, guest_name, guest_location, transaction_id, order_list_id,
    delivery_payment_status, gcash_ref, table_number, order_type
) VALUES (
    'Pending', 3, 'Pedro Ramos', 'Blk 5 Lot 7, Sampaguita St.', 10003, 5003, 'Yes', 'GCASH123456', NULL, 'delivery'
);

-- Order 1: Dine-In (1 Fried Chicken, 1 Spaghetti)
INSERT INTO processing_order_items (
    order_ID, item_id, Item_Type, Quantity, Prep_status, Price_Per_Item
) VALUES
(1, 1, 'normal', 1, 'preparing', 120.00),
(1, 2, 'normal', 1, 'preparing', 95.00);

-- Order 2: Take-Out (2 Burger Steak)
INSERT INTO processing_order_items (
    order_ID, item_id, Item_Type, Quantity, Prep_status, Price_Per_Item
) VALUES
(2, 3, 'normal', 2, 'preparing', 105.00);

-- Order 3: Delivery (1 Fried Chicken, 1 Burger Steak)
INSERT INTO processing_order_items (
    order_ID, item_id, Item_Type, Quantity, Prep_status, Price_Per_Item
) VALUES
(3, 1, 'normal', 1, 'preparing', 120.00),
(3, 3, 'normal', 1, 'preparing', 105.00);

