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


CREATE PROCEDURE updateaccountinfo_personel(
    IN p_id INT, 
    IN p_fname VARCHAR(100), 
    IN p_mname VARCHAR(100), 
    IN p_lname VARCHAR(100), 
    IN p_contactnumber VARCHAR(15), 
    IN p_email VARCHAR(100)
)
BEGIN
    UPDATE restaurant_accounts
    SET 
        first_name = p_fname,
        middle_name = p_mname,
        last_name = p_lname,
        contact_number = p_contactnumber,
        email = p_email
    WHERE account_id = p_id;
END //
    
