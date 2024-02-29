INSERT INTO cofea SELECT DISTINCT COFFEA from fsdb.catalogue;
INSERT INTO origin SELECT DISTINCT ORIGIN from fsdb.catalogue;
INSERT INTO roast SELECT DISTINCT ROASTING from fsdb.catalogue;
INSERT INTO format SELECT DISTINCT FORMAT from fsdb.catalogue;
COMMIT;

INSERT INTO amount (format, quantity)
	SELECT c.FORMAT, to_number(t.QUANTITY)
	FROM fsdb.catalogue c
	JOIN fsdb.trolley t ON c.PRODUCT = t.PRODUCT;
COMMIT;

INSERT INTO product_has_format SELECT DISTINCT FORMAT, PRODUCT from fsdb.catalogue;
INSERT INTO varietal SELECT DISTINCT VARIETAL, COFFEA from fsdb.catalogue;
INSERT INTO product_has_roast SELECT DISTINCT ROASTING, PRODUCT from fsdb.catalogue; 
INSERT INTO product 
	SELECT PRODUCT, VARIETAL, ORIGIN, ROASTING, DECAF, FORMAT, to_number(BARCODE) 
	from fsdb.catalogue;
COMMIT;

INSERT INTO reference SELECT 
	SELECT to_number(c.COST_PRICE), to_number(t.QUANTITY), c.FORMAT, to_number(c.BARCODE), 
	to_number(t.CUR_STOCK), to_number(t.MIN_STOCK), to_number(t.MAX_STOCK)
	FROM fsdb.catalogue c
	JOIN fsdb.trolley t ON c.PRODUCT = t.PRODUCT;
COMMIT;
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
