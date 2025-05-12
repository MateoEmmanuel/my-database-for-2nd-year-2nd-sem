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
        SELECT IL.image_path
        FROM customer_accounts CA
        JOIN image_list IL ON CA.image_id = IL.image_id
        WHERE CA.customer_id = p_id;
    ELSE
        SELECT IL.image_path
        FROM restaurant_accounts RA
        JOIN image_list IL ON RA.image_id = IL.image_id
        WHERE RA.account_id = p_id;
    END IF;
END //