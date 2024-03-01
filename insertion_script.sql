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
SELECT quantity, coalesce(client_mobile, client_email), payment_type, card_number,
DISTINCT to_number(BASE_PRICE), PACKAGING, to_number(QUANTITY), barcode,
to_date(delivery_date), 
DLIV_WAYTYPE, DLIV_WAYNAME, to_number(DLIV_ZIP), 
DLIV_TOWN, DLIV_COUNTRY
FROM fsdb.trolley
WHERE BASE_PRICE, PACKAGING, QUANTITY, BARCODE, 
DLIV_WAYTYPE, DLIV_WAYNAME, DLIV_ZIP
DLIV_TOWN, DLIV_COUNTRY, DLIV_DATE  IS NOT NULL;


insert into providers(
    DISTINCT CIF, NAME, FULL_NAME, EMAIL, PHONE, PROVIDER_ADDRESS
)
SELECT PROV_TAXID, SUPPLIER, PROV_BANKACC 
PROV_ADDRESS CHAR(120)
PROV_COUNTRY CHAR(45)
PROV_PERSON CHAR(90)
PROV_EMAIL CHAR(60)
PROV_MOBILE


insert into opinion(text, score, likes, endorsement, username)
    SELECT DISTINCT TEXT, to_number(SCORE), to_number(LIKES), to_number(ENDORSED), USERNAME
    FROM fsdb.posts;
    WHERE TEXT, SCORE, LIKES IS NOT NULL;

insert into registered_customer(username, password, contact_preference, registration_date, loyalty_discount_voucher)
	SELECT DISTINCT USERNAME, USER_PASSW, COALESCE(CLIENT_MOBILE, CLIENT_EMAIL), to_date(REG_DATE), to_number(DISCOUNT)
	FROM fsdb.trolley;
	WHERE USERNAME, USER_PASSW, REG_DATE IS NOT NULL;

insert into customer(preferred_contact, alternate_contact, buyer_name, buyer_surname, username)
	SELECT DISTINCT COALESCE(CLIENT_MOBILE, CLIENT_EMAIL), CLIENT_EMAIL, CLIENT_NAME, CLIENT_SURN1, USERNAME
	FROM fsdb.trolley;
	WHERE  CLIENT_MOBILE, CLIENT_EMAIL, CLIENT_NAME, CLIENT_SURN1 IS NOT NULL;

insert into credit_card(cardnum, card_holder, company_name, expiration)
	SELECT CARD_HOLDER, CARD_COMPANY, to_date(CARD_EXPIRATN), DISTINCT to_number(CARD_NUMBER)
	FROM fsdb.trolley;
	WHERE CARD_NUMBER, CARD_HOLDER_ CARD_COMPANY, CARD_EXPIRATN IS NOT NULL;

insert into payment_type(type)
	SELECT DISTINCT PAYMENT_TYPE
	FROM fsdb.trolley;
	WHERE PAYMENT_TYPE IS NOT NULL;


