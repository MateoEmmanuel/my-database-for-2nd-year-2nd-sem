DELIMITER //

-- staff procedures
CREATE PROCEDURE UpdatePersonalAccount (
    IN p_first_name VARCHAR(255),
    IN p_middle_name VARCHAR(255),
    IN p_last_name VARCHAR(255),
    IN p_contact_number VARCHAR(20),
    IN p_email VARCHAR(255),
    IN p_account_id INT
)
BEGIN
    UPDATE restaurant_accounts
    SET 
        first_name = p_first_name,
        middle_name = p_middle_name,
        last_name = p_last_name,
        contact_number = p_contact_number,
        email = p_email
    WHERE account_id = p_account_id;
END //

CREATE PROCEDURE UpdatePersonalPassword (
    IN p_account_id INT,
    IN p_new_password VARCHAR(255)
)
BEGIN
    UPDATE restaurant_accounts
    SET password = p_new_password
    WHERE account_id = p_account_id;
END //

CREATE PROCEDURE UpdatePersonalProfilePic (
    IN p_account_id INT,
    IN p_image LONGBLOB
)
BEGIN
    DECLARE new_image_id INT;

    -- Insert new image and get the new image_id
    INSERT INTO Image_List (Image) VALUES (p_image);
    SET new_image_id = LAST_INSERT_ID();

    -- Update the restaurant account to point to the new image
    UPDATE restaurant_accounts
    SET image_id = new_image_id
    WHERE account_id = p_account_id;
END //


-- admin procedures
-- accounts personels
CREATE PROCEDURE CreateAccount(
    IN p_AccountType ENUM('Admin', 'Staff', 'Cashier', 'Kitchen', 'Delivery'),
    IN p_PositionID INT,
    IN p_FirstName VARCHAR(250),
    IN p_MiddleName VARCHAR(250),
    IN p_LastName VARCHAR(250),
    IN p_ContactNumber VARCHAR(15),
    IN p_Email VARCHAR(100),
    IN p_Username VARCHAR(50),
    IN p_Password VARCHAR(255),
    IN p_Image LONGBLOB
)
BEGIN
    DECLARE v_ImageID INT;

    -- Insert the image only if provided
    IF p_Image IS NOT NULL THEN
        INSERT INTO Image_List (Image) VALUES (p_Image);
        SET v_ImageID = LAST_INSERT_ID();
    ELSE
        SET v_ImageID = NULL;
    END IF;

    -- Insert into restaurant_accounts
    INSERT INTO restaurant_accounts (
        account_type,
        position_id,
        image_id,
        first_name,
        middle_name,
        last_name,
        contact_number,
        email,
        username,
        password
    )
    VALUES (
        p_AccountType,
        p_PositionID,
        v_ImageID,
        p_FirstName,
        p_MiddleName,
        p_LastName,
        p_ContactNumber,
        p_Email,
        p_Username,
        p_Password
    );
END //

CREATE PROCEDURE UpdateAccount(
    IN p_AccountID INT,
    IN p_AccountType ENUM('Admin', 'Staff', 'Cashier', 'Kitchen', 'Delivery'),
    IN p_PositionID INT,
    IN p_FirstName VARCHAR(50),
    IN p_MiddleName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_ContactNumber VARCHAR(15),
    IN p_Email VARCHAR(100),
    IN p_Username VARCHAR(50),
    IN p_Password VARCHAR(255),
    IN p_Image LONGBLOB
)
BEGIN
    DECLARE v_ImageID INT;
    DECLARE v_OldImageID INT;

    -- Get current Image_ID to check if it needs updating
    SELECT image_id INTO v_OldImageID
    FROM restaurant_accounts
    WHERE account_id = p_AccountID;

    -- If a new image is provided, insert it and update image_id
    IF p_Image IS NOT NULL THEN
        INSERT INTO Image_List (Image) VALUES (p_Image);
        SET v_ImageID = LAST_INSERT_ID();
    ELSE
        SET v_ImageID = v_OldImageID;
    END IF;

    -- Update restaurant_accounts
    UPDATE restaurant_accounts
    SET
        account_type = p_AccountType,
        position_id = p_PositionID,
        image_id = v_ImageID,
        first_name = p_FirstName,
        middle_name = p_MiddleName,
        last_name = p_LastName,
        contact_number = p_ContactNumber,
        email = p_Email,
        username = p_Username,
        password = p_Password
    WHERE account_id = p_AccountID;
END //

CREATE PROCEDURE DeleteAccount(
    IN p_AccountID INT
)
BEGIN
    -- Simply delete the account; image will be deleted via ON DELETE CASCADE
    DELETE FROM restaurant_accounts
    WHERE account_id = p_AccountID;
END //

-- positions
CREATE PROCEDURE CreatePosition(
    IN p_PositionName VARCHAR(100),
    IN p_Salary DECIMAL(10, 2)
)
BEGIN
    -- Insert new position
    INSERT INTO Position_List (Position_name, Salary)
    VALUES (p_PositionName, p_Salary);
END //

CREATE PROCEDURE UpdatePosition(
    IN p_PositionID INT,
    IN p_PositionName VARCHAR(100),
    IN p_Salary DECIMAL(10, 2)
)
BEGIN
    -- Update the position details
    UPDATE Position_List
    SET Position_name = p_PositionName,
        Salary = p_Salary
    WHERE Position_ID = p_PositionID;
END //

CREATE PROCEDURE DeletePosition(
    IN p_PositionID INT
)
BEGIN
    -- Check if the position is used by any account
    DECLARE v_Count INT;

    SELECT COUNT(*) INTO v_Count
    FROM restaurant_accounts
    WHERE position_id = p_PositionID;

    -- If no accounts are using this position, delete it
    IF v_Count = 0 THEN
        DELETE FROM Position_List
        WHERE Position_ID = p_PositionID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete position. It is being used by one or more accounts.';
    END IF;
END //

DELIMITER ;

