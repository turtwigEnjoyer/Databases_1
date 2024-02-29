--- All of product & reference; Noam
-- Providers, orders purchase and addresses; Nora
-- And client info, crredit cards, comment -> Laura


insert into address(type, name, gate, block_number, stairs, floor, door, zip, town, country) 
    SELECT DISTINCT DLIV_WAYTYPE, DLIV_WAYNAME, 
    DLIV_GATE, to_number(DLIV_BLOCK), DLIV_STAIRW,
    to_number(DLIV_FLOOR), DLIV_DOOR, to_number(DLIV_ZIP), 
    DLIV_TOWN, DLIV_COUNTRY
    FROM fsdb.trolley;
    WHERE DLIV_WAYNAME, DLIV_WAYTYPE, DLIV_ZIP, DLIV_COUNTRY, DLIV_TOWN IS NOT NULL;


insert into opinion(text, score, likes, endorsement, username)
    SELECT to_number(SCORE), to_number(LIKES), to_number(ENDORSED), USERNAME, DISTINCT TEXT
    FROM fsdb.posts;
    WHERE TEXT, SCORE, LIKES IS NOT NULL;

insert into registered_customer(username, password, contact_preference, registration_date, loyalty_discount_voucher)
    SELECT USER_PASSW,  
