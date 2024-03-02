
-- Create tables

DROP TABLE address cascade constraints;
DROP TABLE origin cascade constraints;
DROP TABLE coffea cascade constraints;
DROP TABLE varietal cascade constraints;
DROP TABLE product cascade constraints;
DROP TABLE format cascade constraints;
DROP TABLE product_has_format cascade constraints;
DROP TABLE roast cascade constraints;
DROP TABLE product_has_roast cascade constraints;
DROP TABLE provider cascade constraints;
DROP TABLE amount cascade constraints;
DROP TABLE prod_reference cascade constraints;
DROP TABLE provider_has_reference cascade constraints;
DROP TABLE provider_order cascade constraints;
DROP TABLE payment_type cascade constraints;
DROP TABLE credit_card cascade constraints;
DROP TABLE contact_preference cascade constraints;
DROP TABLE registered_customer cascade constraints;
DROP TABLE opinion cascade constraints;
DROP TABLE customer cascade constraints;
DROP TABLE purchase cascade constraints;
DROP TABLE BARCODE CASCADE CONSTRAINTS;
DROP TABLE AMOUNT_HAS_FORMAT CASCADE CONSTRAINTS;


CREATE TABLE address
(
    type VARCHAR(45),
    name VARCHAR(45),
    zip NUMBER(7),
    country VARCHAR(45),
    town VARCHAR(45),
    gate VARCHAR(10),
    floor NUMBER(3),
    block_number NUMBER(3),
    stairs VARCHAR(10),
    door VARCHAR(10),
    CONSTRAINT address_pk PRIMARY KEY(type, name, zip, country, town)
);

CREATE TABLE origin
(
    name VARCHAR(45),
    CONSTRAINT origin_pk PRIMARY KEY(name)
);

CREATE TABLE coffea
(
    name VARCHAR(45),
    CONSTRAINT coffea_pk PRIMARY KEY(name)
);

CREATE TABLE varietal
(
    name VARCHAR(45),
    coffea_name VARCHAR(45) NOT NULL, 
    CONSTRAINT varietal_pk PRIMARY KEY(name),
    CONSTRAINT coffea_fk FOREIGN KEY (coffea_name) references coffea(name)
);

CREATE TABLE product
(
    name VARCHAR(50),
    varietal_name VARCHAR(45) NOT NULL,
    origin_name VARCHAR(45) NOT NULL,
    decaf VARCHAR(3) NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY(name),
    CONSTRAINT origin_fk FOREIGN KEY (origin_name) REFERENCES origin(name),
    CONSTRAINT varietal_fk FOREIGN KEY (varietal_name) references varietal(name)
);

CREATE TABLE BARCODE(
    product_name VARCHAR2(50) NOT NULL,
    bcode VARCHAR2(45),
    CONSTRAINT barcode_pk PRIMARY KEY(bcode),
    CONSTRAINT prod_barcode_fk FOREIGN KEY(product_name) references PRODUCT(name)
);

CREATE TABLE format
(
    format_type VARCHAR(45),
    CONSTRAINT format_pk PRIMARY KEY(format_type)
);

CREATE TABLE product_has_format
(
    format_format_type VARCHAR(45),
    product_name VARCHAR(50),
    CONSTRAINT product_has_format_pk PRIMARY KEY(format_format_type, product_name),
    CONSTRAINT product_fk FOREIGN KEY(product_name) references product(name),
    constraint format_fk FOREIGN KEY(format_format_type) references format(format_type)
);

CREATE TABLE roast
(
    roast_type VARCHAR(45),
    CONSTRAINT roast_pk PRIMARY KEY(roast_type)
);

CREATE TABLE product_has_roast
(
    roast_roast_type VARCHAR(45),
    product_name VARCHAR(50),
    CONSTRAINT product_has_roast_pk PRIMARY KEY(roast_roast_type, product_name),
    CONSTRAINT product_roast_fk FOREIGN KEY(product_name) references product(name),
    CONSTRAINT roast_fk FOREIGN KEY(roast_roast_type) references roast(roast_type)
);
CREATE TABLE product_has_varietal(
    varietal_name VARCHAR(45),
    product_name VARCHAR(45),
    CONSTRAINT product_has_varietal_pk PRIMARY KEY(varietal_name, product_name),
    CONSTRAINT product_varietal_fk FOREIGN KEY(product_name) references product(name),
    CONSTRAINT hasvarietal_fk FOREIGN KEY(varietal_name) references varietal(name)
)
CREATE TABLE product_has_origin(
    origin_name VARCHAR(45),
    product_name VARCHAR(45),
    CONSTRAINT product_has_origin_pk PRIMARY KEY(origin_name, product_name),
    CONSTRAINT product_varietal_fk FOREIGN KEY(product_name) references product(name),
    CONSTRAINT hasorigin_fk FOREIGN KEY(origin_name) references origin(name)
)

CREATE TABLE provider
(
    CIF VARCHAR2(15),
    name VARCHAR(45) NOT NULL,
    full_name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    phone VARCHAR(45) NOT NULL,
    bank_account VARCHAR(45),
    provider_address VARCHAR(120) NOT NULL,
    country VARCHAR(45),
    average_delivery_time NUMBER(15),
    num_of_deliveries_past_year NUMBER(15) DEFAULT 0 NOT NULL,
    CONSTRAINT provider_pk PRIMARY KEY(CIF)
);

CREATE TABLE amount
(
    quantity VARCHAR(45),
    CONSTRAINT amount_pk PRIMARY KEY(quantity)
);

CREATE TABLE amount_has_format(
    quantity VARCHAR(45),
    format_type VARCHAR(45),
    CONSTRAINT amount_has_format_pk PRIMARY KEY(quantity, format_type),
    CONSTRAINT amounthas_format_fk FOREIGN KEY(format_type) references format(format_type),
    CONSTRAINT has_amount_fk FOREIGN KEY(quantity) references amount(quantity)
);

CREATE TABLE prod_reference
(
    price NUMBER(15),
    amount VARCHAR2(45),
    bcode VARCHAR(45),
    stock NUMBER(15) DEFAULT 0,
    minim NUMBER(15) DEFAULT 5,
    maxim NUMBER(15) DEFAULT 15,
    CONSTRAINT reference_pk PRIMARY KEY(price, amount, bcode),
    CONSTRAINT amount_fk FOREIGN KEY(amount) references amount(quantity),
    CONSTRAINT prod_fk FOREIGN KEY(bcode) references barcode(bcode)
);


CREATE TABLE provider_has_reference
(
    price NUMBER(15),
    amount VARCHAR2(45),
    bcode VARCHAR2(45),
    provider_CIF VARCHAR2(15),
    provider_reference_price NUMBER(15),
    CONSTRAINT provider_has_reference_pk PRIMARY KEY(price, amount, bcode, provider_CIF),
    CONSTRAINT fk_provider_reference FOREIGN KEY(price, amount, bcode) references prod_reference(price, amount, bcode),
    CONSTRAINT fk_phr_provider FOREIGN KEY(provider_CIF) references provider(CIF)
); 

CREATE TABLE provider_order
(
    price NUMBER(15),
    amount VARCHAR(45),
    bcode VARCHAR(45),
    order_date DATE NOT NULL,
    placed_date DATE,
    total_payment NUMBER(15),
    fulfilled_date DATE,
    provider_CIF VARCHAR2(15),
    CONSTRAINT order_pk PRIMARY KEY(price, amount, bcode, order_date),
    CONSTRAINT fk_reference FOREIGN KEY(price, amount, bcode) references prod_reference(price, amount, bcode),
    CONSTRAINT fk_provider FOREIGN KEY(provider_CIF) references PROVIDER(CIF)
);

CREATE TABLE payment_type
(
    type VARCHAR(45) NOT NULL,
    CONSTRAINT payment_type_pk PRIMARY KEY(type)
);

CREATE TABLE credit_card
(
    cardnum NUMBER(15),
    card_holder VARCHAR(45) NOT NULL,
    company_name VARCHAR(45) NOT NULL,
    expiration DATE NOT NULL,
    CONSTRAINT credit_card_pk PRIMARY KEY(cardnum)
);

CREATE TABLE contact_preference
(
    type VARCHAR2(45),
    CONSTRAINT pk PRIMARY KEY(type)
);

CREATE TABLE registered_customer
(
    username VARCHAR(45),
    password VARCHAR(45) NOT NULL,
    contact_preference VARCHAR(60) NOT NULL,
    registration_date DATE NOT NULL,
    loyalty_discount_voucher VARCHAR(15),
    CONSTRAINT registered_customer_pk PRIMARY KEY(username),
    CONSTRAINT contact_preference_fk FOREIGN KEY(contact_preference) references CONTACT_PREFERENCE(type)
);

CREATE TABLE opinion
(
    textop VARCHAR(2000),
    score NUMBER(15) DEFAULT 0 NOT NULL,
    likes NUMBER(15) DEFAULT 0 NOT NULL,
    endorsement NUMBER(15),
    username VARCHAR(45),
    CONSTRAINT opinion_pk PRIMARY KEY(textop),
    CONSTRAINT fk_registered_customer FOREIGN KEY(username) references REGISTERED_CUSTOMER(username)
);

CREATE TABLE customer
(
    preferred_contact VARCHAR(70),
    alternate_contact VARCHAR(70),
    buyer_name VARCHAR(45) NOT NULL,
    buyer_surname VARCHAR(45) NOT NULL,
    username VARCHAR(45),
    CONSTRAINT customer_pk PRIMARY KEY(preferred_contact),
    CONSTRAINT registered_customer_fk FOREIGN KEY(username) references REGISTERED_CUSTOMER(username)
);


CREATE TABLE purchase
(
    reference_price NUMBER(15),
    reference_amount VARCHAR(45),
    reference_barcode VARCHAR(45),
    delivery_date DATE,
    address_type VARCHAR(45),
    address_name VARCHAR(45),
    address_zip NUMBER(7),
    address_country VARCHAR(45),
    address_town VARCHAR(45),
    units NUMBER(15) NOT NULL,
    total_pay NUMBER(15),
    customer_preferred_contact VARCHAR(70) NOT NULL,
    payment_type VARCHAR(45) NOT NULL,
    credit_card_cardnum NUMBER(20),
    CONSTRAINT purchase_pk PRIMARY KEY(reference_price, reference_amount, reference_barcode, delivery_date, address_name, address_zip, address_country, address_town),
    CONSTRAINT purchase_amount_fk FOREIGN KEY(reference_amount) references AMOUNT(quantity),
    CONSTRAINT purchase_address_fk FOREIGN KEY(address_type, address_name, address_zip, address_country, address_town) references address(type, name, zip, country, town),
    CONSTRAINT purchase_fk_reference FOREIGN KEY(reference_price, reference_amount, reference_barcode) references prod_reference(price, amount, bcode),
    CONSTRAINT purchase_payment_type_fk FOREIGN KEY(payment_type) references payment_type(type),
    CONSTRAINT purchase_credit_card_fk FOREIGN KEY(credit_card_cardnum) references credit_card(cardnum),
    CONSTRAINT purchase_customer_fk FOREIGN KEY(customer_preferred_contact) references customer(preferred_contact)
);

CREATE INDEX address_per_client_town
    ON purchase(address_town, customer_preferred_contact);

