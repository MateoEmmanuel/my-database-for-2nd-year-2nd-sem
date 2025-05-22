Delimiter //
CREATE PROCEDURE GetUsernameByRole (
    IN p_user_id INT,
    IN p_role Varchar(100)
)
BEGIN
    IF p_role = 'Customer' THEN
        SELECT customer_username AS username
        FROM customer_accounts
        WHERE customer_id = p_user_id;
    ELSE
        SELECT username
        FROM restaurant_accounts
        WHERE account_id = p_user_id;
    END IF;
END //


CREATE PROCEDURE GetProfileImageByRole (
    IN p_id INT,
    IN p_role VARCHAR(50)
)
BEGIN
    IF p_role = 'Customer' THEN
        SELECT IL.image
        FROM customer_accounts CA
        JOIN image_list IL ON CA.image_id = IL.image_id
        WHERE CA.customer_id = p_id;
    ELSE
        SELECT IL.image
        FROM restaurant_accounts RA
        JOIN image_list IL ON RA.image_id = IL.image_id
        WHERE RA.account_id = p_id;
    END IF;
END //

CREATE PROCEDURE getaccountinfo_personel(IN p_id INT)
BEGIN
    SELECT 
		ra.username,
        ra.first_name,
        ra.middle_name,
        ra.last_name,
        ra.contact_number,
        ra.email,
        pl.Position_name
    FROM restaurant_accounts ra
    JOIN Position_List pl ON ra.position_id = pl.Position_ID
    WHERE ra.account_id = p_id;
END //


CREATE PROCEDURE UpdateAccountInfo_personel (
	IN p_id int,
    IN p_username VARCHAR(50),
    IN p_firstname VARCHAR(50),
    IN p_middlename VARCHAR(50),
    IN p_lastname VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_contact VARCHAR(25)
)
BEGIN
    -- Update Account details
    UPDATE restaurant_accounts
    SET 
        First_Name = p_firstname,
        Middle_Name = p_middlename,
        Last_Name = p_lastname,
        Email = p_email,
        Contact_Number = p_contact
    WHERE Account_ID = p_id;
END //

CREATE PROCEDURE UpdateProfilePicture_personel (
    IN p_account_id INT,
    IN p_image LONGBLOB
)
BEGIN
    DECLARE existing_image_id INT;

    -- Get current image_id of the user
    SELECT image_id INTO existing_image_id
    FROM restaurant_accounts
    WHERE account_id = p_account_id;

    IF existing_image_id IS NULL THEN
        -- Insert new image if none exists
        INSERT INTO Image_List (Image)
        VALUES (p_image);

        SET existing_image_id = LAST_INSERT_ID();

        -- Update restaurant_accounts with new image_id
        UPDATE restaurant_accounts
        SET image_id = existing_image_id
        WHERE account_id = p_account_id;
    ELSE
        -- Update existing image
        UPDATE Image_List
        SET Image = p_image
        WHERE Image_ID = existing_image_id;
    END IF;
END //
     
    
CREATE PROCEDURE loging_walk_in_order (
    IN p_order_id INT,
    IN p_transaction_id VARCHAR(25),
    IN p_cashier_id INT,
    IN p_discount_id INT,
    IN p_total_price DECIMAL(10,2),
    IN p_payment_method text,
    IN p_order_type ENUM('delivery', 'walk-in'),
    IN p_customer_id INT,
    IN p_customer_account_type ENUM('customer','guest'),
    OUT p_or_logs_id INT
)
BEGIN
    -- Insert into Ordered_Logs
    INSERT INTO Ordered_Logs (
        Transaction_ID,
        customer_id,
        customer_account_type,
        cashier_id,
        Discount_ID,
        Total_Price,
        payment_method,
        order_type,
        status
    ) VALUES (
        p_transaction_id,
        p_customer_id,
        p_customer_account_type,
        p_cashier_id,
        p_discount_id,
        p_total_price,
        p_payment_method,
        p_order_type,
        'paid'
    );

    -- Return the last inserted ID
    SET p_or_logs_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE log_order_items (
    IN p_order_list_id INT,
    IN p_or_logs_id INT
)
BEGIN
    -- Insert all related items from processing_order_items to Ordered_Items
    INSERT INTO Ordered_Items (
        Or_Logs_ID,
        item_id,
        Item_Type,
        Quantity,
        Price_Per_Item
    )
    SELECT
        p_or_logs_id,
        item_id,
        Item_Type,
        Quantity,
        Price_Per_Item
    FROM processing_order_items
    WHERE order_list_ID = p_order_list_id;
END //

DELIMITER ;
