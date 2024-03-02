INSERT INTO cofea SELECT DISTINCT COFFEA from fsdb.catalogue;
INSERT INTO origin SELECT DISTINCT ORIGIN from fsdb.catalogue;
INSERT INTO roast SELECT DISTINCT ROASTING from fsdb.catalogue;
INSERT INTO format SELECT DISTINCT FORMAT from fsdb.catalogue;
COMMIT;

INSERT INTO amount (format_format_type, quantity) SELECT DISTINCT FORMAT, PACKAGING from fsdb.catalogue;
COMMIT;

INSERT INTO product_has_format SELECT DISTINCT FORMAT, PRODUCT from fsdb.catalogue;
INSERT INTO varietal SELECT DISTINCT VARIETAL, COFFEA from fsdb.catalogue;
INSERT INTO product_has_roast SELECT DISTINCT ROASTING, PRODUCT from fsdb.catalogue; 
INSERT INTO product 
	SELECT DISTINCT PRODUCT, VARIETAL, ORIGIN, DECAF, BARCODE
	from fsdb.catalogue;
COMMIT;

INSERT INTO reference (cost_price, quantity, format, barcode, cur_stock, min_stock, max_stock)
SELECT 
	DISTINCT
    TO_NUMBER(c.COST_PRICE),
    c.PACKAGING,
    c.FORMAT,
    c.BARCODE,
    TO_NUMBER(c.CUR_STOCK),
    TO_NUMBER(c.MIN_STOCK),
    TO_NUMBER(c.MAX_STOCK)
FROM 
    fsdb.catalogue c;
COMMIT;
-- Providers, orders purchase and addresses; Nora
-- And client info, crredit cards, comment -> Laura


insert into address(gate, block_number, stairs, floor, door, type, name, zip, town, country) 
SELECT DISTINCT
	DLIV_GATE, to_number(DLIV_BLOCK),
	DLIV_STAIRW,
	to_number(DLIV_FLOOR),
	DLIV_DOOR,
	DLIV_WAYTYPE, DLIV_WAYNAME, to_number(DLIV_ZIP),
	DLIV_TOWN, DLIV_COUNTRY
FROM fsdb.trolley
WHERE DLIV_WAYNAME IS NOT NULL AND DLIV_WAYTYPE IS NOT NULL AND DLIV_ZIP IS NOT NULL AND DLIV_COUNTRY
IS NOT NULL AND DLIV_TOWN IS NOT NULL AND (VALIDATE_CONVERSION(DLIV_FLOOR AS NUMBER) = 1);

insert all
INTO contact_preference(type) values('email')
INTO contact_preference(type) values('phonecall')
INTO contact_preference(type) values('sms')
INTO contact_preference(type) values('whatsapp')
INTO contact_preference(type) values('facebook')
INTO contact_preference(type) values('wechat')
INTO contact_preference(type) values('qqmobile')
INTO contact_preference(type) values('snapchat')
INTO contact_preference(type) values('telegram')
select * from dual;


insert into purchase(
    units,
    customer_preferred_contact,
    payment_type, credit_card_cardnum,
    reference_price, format_format_type, reference_amount, reference_barcode,
    delivery_date,
    address_type, address_name, address_zip, address_country, address_town,
	total_pay
)
SELECT DISTINCT quantity, 
coalesce(client_mobile, client_email),
payment_type, card_number,
to_number(translate(translate(base_price, '_c', '_'), '_.', '_,')), PACKAGING, QUANTITY, barcode,
to_date(DLIV_DATE, 'YYYY/MM/DD'), 
DLIV_WAYTYPE, DLIV_WAYNAME, to_number(DLIV_ZIP), 
DLIV_TOWN, DLIV_COUNTRY,
(to_number(translate(translate(base_price, '_c', '_'), '_.', '_,'))*QUANTITY)
FROM fsdb.trolley
WHERE BASE_PRICE IS NOT NULL AND PACKAGING IS NOT NULL AND QUANTITY IS NOT NULL AND BARCODE IS NOT NULL
AND DLIV_WAYTYPE IS NOT NULL AND DLIV_WAYNAME IS NOT NULL AND DLIV_ZIP IS NOT NULL
AND DLIV_TOWN IS NOT NULL AND DLIV_COUNTRY IS NOT NULL AND DLIV_DATE IS NOT NULL 
AND coalesce(client_mobile, client_email) IS NOT NULL;


insert into provider(
    CIF, NAME, PROVIDER_ADDRESS, COUNTRY, FULL_NAME, EMAIL, PHONE, bank_account
)
SELECT DISTINCT TO_NUMBER(PROV_TAXID), SUPPLIER,
PROV_ADDRESS,
PROV_COUNTRY,
PROV_PERSON,
PROV_EMAIL,
PROV_MOBILE,
PROV_BANKACC
FROM fsdb.catalogue
WHERE PROV_TAXID IS NOT NULL AND SUPPLIER IS NOT NULL AND PROV_ADDRESS IS NOT NULL AND PROV_COUNTRY IS NOT NULL
AND PROV_PERSON IS NOT NULL AND PROV_EMAIL IS NOT NULL AND PROV_MOBILE IS NOT NULL;

insert into provider_has_reference(
	price,
    amount,
	format_format_type,
    barcode,
    provider_CIF,
    provider_reference_price
)
SELECT DISTINCT
	TO_NUMBER(RETAIL_PRICE), PACKAGING, FORMAT, BARCODE, TO_NUMBER(PROV_TAXID), TO_NUMBER(COST_PRICE)
FROM FSDB.catalogue
where RETAIL_PRICE IS NOT NULL AND PACKAGING IS NOT NULL AND FORMAT IS NOT NULL AND BARCODE IS NOT NULL 
AND PROV_TAXID IS NOT NULL;





insert into opinion(textop, score, likes, endorsement, username)
    SELECT DISTINCT TEXT, to_number(SCORE), to_number(LIKES), to_number(ENDORSED), USERNAME
    FROM fsdb.posts
    WHERE TEXT IS NOT NULL AND SCORE IS NOT NULL AND LIKES IS NOT NULL;

INSERT INTO registered_customer (username, password, contact_preference, registration_date, loyalty_discount_voucher)
SELECT DISTINCT
    USERNAME,
    USER_PASSW,
    CASE
        WHEN CLIENT_MOBILE IS NOT NULL THEN 'sms'
        WHEN CLIENT_EMAIL IS NOT NULL THEN 'email'
    END AS contact_preference,
    TO_DATE(REG_DATE, 'YYYY/MM/DD'),
    DISCOUNT
FROM fsdb.trolley
WHERE
    USERNAME IS NOT NULL
    AND USER_PASSW IS NOT NULL
    AND (CLIENT_MOBILE IS NOT NULL OR CLIENT_EMAIL IS NOT NULL)
    AND REG_DATE IS NOT NULL;


insert into customer(preferred_contact, alternate_contact, buyer_name, buyer_surname, username)
	SELECT DISTINCT
		COALESCE(
			CASE 
			    WHEN CLIENT_MOBILE IS NOT NULL THEN CLIENT_MOBILE
			    WHEN CLIENT_EMAIL IS NOT NULL THEN NULL
			END,
			CLIENT_EMAIL
		) AS preferred_contact,
		CASE 
			WHEN CLIENT_MOBILE IS NOT NULL THEN CLIENT_EMAIL
			ELSE NULL
		END AS alternate_contact,
		CLIENT_NAME,
		CLIENT_SURN1,
		USERNAME
	FROM fsdb.trolley
	WHERE (CLIENT_MOBILE IS NOT NULL OR CLIENT_EMAIL IS NOT NULL) AND CLIENT_NAME IS NOT NULL AND CLIENT_SURN1 IS NOT NULL;

insert into credit_card(cardnum, card_holder, company_name, expiration)
	SELECT DISTINCT to_number(CARD_NUMBER), CARD_HOLDER, CARD_COMPANY, to_date(CARD_EXPIRATN, 'MM/YY')
  	FROM fsdb.trolley
  	WHERE CARD_NUMBER IS NOT NULL AND CARD_HOLDER IS NOT NULL AND CARD_COMPANY IS NOT NULL AND CARD_EXPIRATN IS NOT NULL;

insert into payment_type(type)
	SELECT DISTINCT PAYMENT_TYPE
	FROM fsdb.trolley
	WHERE PAYMENT_TYPE IS NOT NULL;


