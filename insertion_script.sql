--- All of product & reference; Noam
-- Providers, orders purchase and addresses; Nora
-- And client info, crredit cards, comment -> Laura


insert into address(gate, block_number, stairs, floor, door, type, name, zip, town, country) 
    SELECT DLIV_GATE, to_number(DLIV_BLOCK), DLIV_STAIRW,
    to_number(DLIV_FLOOR), DLIV_DOOR,
    DISTINCT DLIV_WAYTYPE, DLIV_WAYNAME, to_number(DLIV_ZIP), 
    DLIV_TOWN, DLIV_COUNTRY
    FROM fsdb.trolley
    WHERE DLIV_WAYNAME, DLIV_WAYTYPE, DLIV_ZIP, DLIV_COUNTRY, DLIV_TOWN IS NOT NULL;

insert into purchase(
    units,
    customer_preferred_contact,
    payment_type,
    credit_card_cardnum,
    reference_price, format_format_type, reference_amount, reference_barcode,
    delivery_date,
    address_type, address_name, address_zip, address_country, address_town
)
SELECT quantity, client_mobile, payment_type, card_number,
DISTINCT to_number(BASE_PRICE), PACKAGING, to_number(QUANTITY), barcode,
to_date(delivery_date), 
DLIV_WAYTYPE, DLIV_WAYNAME, to_number(DLIV_ZIP), 
DLIV_TOWN, DLIV_COUNTRY
FROM fsdb.trolley
WHERE BASE_PRICE, PACKAGING, QUANTITY, BARCODE IS NOT NULL;




insert into opinion(text, score, likes, endorsement, username)
    SELECT to_number(SCORE), to_number(LIKES), to_number(ENDORSED), USERNAME, DISTINCT TEXT
    FROM fsdb.posts;
    WHERE TEXT, SCORE, LIKES IS NOT NULL;

insert into registered_customer(username, password, contact_preference, registration_date, loyalty_discount_voucher)
    SELECT USER_PASSW,  
