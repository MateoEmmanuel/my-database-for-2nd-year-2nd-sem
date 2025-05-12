CREATE TRIGGER trg_accounts_insert
AFTER INSERT ON restaurant_accounts
FOR EACH ROW
INSERT INTO System_Log (
    account_id,
    Action_Type,
    Table_Name,
    Affected_Row_ID,
    Old_Data,
    NEW_Data,
    Full_Details
)
VALUES (
    NEW.account_id,
    'INSERT',
    'restaurant_accounts',
    NEW.account_id,
    '{}',
    JSON_OBJECT(
        'account_type', NEW.account_type,
        'position_id', NEW.position_id,
        'image_id', NEW.image_id,
        'first_name', NEW.first_name,
        'middle_name', NEW.middle_name,
        'last_name', NEW.last_name,
        'contact_number', NEW.contact_number,
        'email', NEW.email,
        'username', NEW.username,
        'availability', NEW.availability
    ),
    CONCAT('Account created: ', NEW.first_name, ' ', NEW.last_name)
);

CREATE TRIGGER trg_accounts_update
AFTER UPDATE ON restaurant_accounts
FOR EACH ROW
INSERT INTO System_Log (
    account_id,
    Action_Type,
    Table_Name,
    Affected_Row_ID,
    Old_Data,
    NEW_Data,
    Full_Details
)
VALUES (
    NEW.account_id,
    'UPDATE',
    'restaurant_accounts',
    NEW.account_id,
    JSON_OBJECT(
        'account_type', OLD.account_type,
        'position_id', OLD.position_id,
        'image_id', OLD.image_id,
        'first_name', OLD.first_name,
        'middle_name', OLD.middle_name,
        'last_name', OLD.last_name,
        'contact_number', OLD.contact_number,
        'email', OLD.email,
        'username', OLD.username,
        'availability', OLD.availability
    ),
    JSON_OBJECT(
        'account_type', NEW.account_type,
        'position_id', NEW.position_id,
        'image_id', NEW.image_id,
        'first_name', NEW.first_name,
        'middle_name', NEW.middle_name,
        'last_name', NEW.last_name,
        'contact_number', NEW.contact_number,
        'email', NEW.email,
        'username', NEW.username,
        'availability', NEW.availability
    ),
    CONCAT('Account updated: ', OLD.first_name, ' -> ', NEW.first_name)
);

CREATE TRIGGER trg_accounts_delete
AFTER DELETE ON restaurant_accounts
FOR EACH ROW
INSERT INTO System_Log (
    account_id,
    Action_Type,
    Table_Name,
    Affected_Row_ID,
    Old_Data,
    NEW_Data,
    Full_Details
)
VALUES (
    OLD.account_id,
    'DELETE',
    'restaurant_accounts',
    OLD.account_id,
    JSON_OBJECT(
        'account_type', OLD.account_type,
        'position_id', OLD.position_id,
        'image_id', OLD.image_id,
        'first_name', OLD.first_name,
        'middle_name', OLD.middle_name,
        'last_name', OLD.last_name,
        'contact_number', OLD.contact_number,
        'email', OLD.email,
        'username', OLD.username,
        'availability', OLD.availability
    ),
    '{}',
    CONCAT('Account deleted: ', OLD.first_name, ' ', OLD.last_name)
);
