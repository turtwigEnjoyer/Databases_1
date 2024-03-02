
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
    name VARCHAR(45),
    varietal_name VARCHAR(45) NOT NULL,
    origin_name VARCHAR(45) NOT NULL,
    decaf VARCHAR(5) NOT NULL,
    barcode NUMBER(15) NOT NULL UNIQUE,
    CONSTRAINT product_pk PRIMARY KEY(name),
    CONSTRAINT origin_fk FOREIGN KEY (origin_name) REFERENCES origin(name),
    CONSTRAINT varietal_fk FOREIGN KEY (varietal_name) references varietal(name)
);

CREATE TABLE format
(
    format_type VARCHAR(45),
    CONSTRAINT format_pk PRIMARY KEY(format_type)
);

CREATE TABLE product_has_format
(
    format_format_type VARCHAR(45),
    product_name VARCHAR(45),
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
    product_name VARCHAR(45),
    CONSTRAINT product_has_roast_pk PRIMARY KEY(roast_roast_type, product_name),
    CONSTRAINT product_roast_fk FOREIGN KEY(product_name) references product(name),
    CONSTRAINT roast_fk FOREIGN KEY(roast_roast_type) references roast(roast_type)
);



CREATE TABLE provider
(
    CIF NUMBER(15),
    name VARCHAR(45) NOT NULL,
    full_name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    phone VARCHAR(45) NOT NULL,
    average_delivery_time NUMBER(15),
    num_of_deliveries_past_year NUMBER(15) DEFAULT 0 NOT NULL,
    provider_address VARCHAR(200) NOT NULL,
    CONSTRAINT provider_pk PRIMARY KEY(CIF),
    CONSTRAINT address_fk FOREIGN KEY(address_type, address_name, address_zip, address_country, address_town) references address
);

CREATE TABLE amount
(
    format_format_type VARCHAR(45) NOT NULL,
    quantity VARCHAR(45) NOT NULL,
    CONSTRAINT amount_pk PRIMARY KEY(format_format_type, quantity),
    CONSTRAINT format_amount_fk FOREIGN KEY(format_format_type) references format(format_type)
);

CREATE TABLE prod_reference
(
    price NUMBER(15),
    amount NUMBER(15),
    format_format_type VARCHAR2(45),
    barcode NUMBER(15),
    stock NUMBER(15) NOT NULL,
    minim NUMBER(15) NOT NULL,
    maxim NUMBER(15) NOT NULL,
    CONSTRAINT reference_pk PRIMARY KEY(price, amount, barcode),
    CONSTRAINT amount_fk FOREIGN KEY(amount, format_format_type) references amount(quantity, format_format_type),
    CONSTRAINT prod_fk FOREIGN KEY(barcode) references product(barcode)
);


CREATE TABLE provider_has_reference
(
    price NUMBER(15),
    amount NUMBER(15),
    barcode NUMBER(15),
    provider_CIF NUMBER(15) ,
    provider_reference_price NUMBER(15),
    CONSTRAINT provider_has_reference_pk PRIMARY KEY(price, amount, barcode, provider_CIF),
    CONSTRAINT fk_provider_reference FOREIGN KEY(price, amount, barcode) references prod_reference(price, amount, barcode)
);

CREATE TABLE provider_order
(
    price NUMBER(15),
    amount NUMBER(15),
    barcode NUMBER(15),
    order_date DATE NOT NULL,
    placed_date DATE,
    total_payment NUMBER(15),
    fulfilled_date DATE,
    provider_CIF NUMBER(15),
    CONSTRAINT order_pk PRIMARY KEY(price, amount, barcode, order_date),
    CONSTRAINT fk_reference FOREIGN KEY(price, amount, barcode) references prod_reference(price, amount, barcode),
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
    contact_preference VARCHAR(45) NOT NULL,
    registration_date DATE NOT NULL,
    loyalty_discount_voucher NUMBER(15),
    CONSTRAINT registered_customer_pk PRIMARY KEY(username),
    CONSTRAINT contact_preference_fk FOREIGN KEY(contact_preference) references CONTACT_PREFERENCE(type)
);

CREATE TABLE opinion
(
    text VARCHAR(45),
    score NUMBER(15) DEFAULT 0 NOT NULL,
    likes NUMBER(15) DEFAULT 0 NOT NULL,
    endorsement NUMBER(15),
    username VARCHAR(45),
    CONSTRAINT opinion_pk PRIMARY KEY(text),
    CONSTRAINT fk_registered_customer FOREIGN KEY(username) references REGISTERED_CUSTOMER(username)
);

CREATE TABLE customer
(
    preferred_contact VARCHAR(45),
    alternate_contact VARCHAR(45),
    buyer_name VARCHAR(45) NOT NULL,
    buyer_surname VARCHAR(45) NOT NULL,
    username VARCHAR(45),
    CONSTRAINT customer_pk PRIMARY KEY(preferred_contact),
    CONSTRAINT registered_customer_fk FOREIGN KEY(username) references REGISTERED_CUSTOMER(username)
);


CREATE TABLE purchase
(
    reference_price NUMBER(15),
    format_format_type VARCHAR(45),
    reference_amount NUMBER(15),
    reference_barcode NUMBER(15),
    delivery_date DATE,
    address_type VARCHAR(45),
    address_name VARCHAR(45),
    address_zip VARCHAR(45),
    address_country VARCHAR(45),
    address_town VARCHAR(45),
    units NUMBER(15) NOT NULL,
    total_pay NUMBER(15),
    customer_preferred_contact VARCHAR(60) NOT NULL,
    payment_type VARCHAR(45) NOT NULL,
    credit_card_cardnum NUMBER(20),
    CONSTRAINT purchase_pk PRIMARY KEY(reference_price, reference_amount, reference_barcode, delivery_date, address_name, address_zip, address_country, address_town),
    CONSTRAINT purchase_amount_fk FOREIGN KEY(format_format_type, reference_amount) references AMOUNT(format_format_type, quantity),
    CONSTRAINT purchase_address_fk FOREIGN KEY(address_type, address_name, address_zip, address_country, address_town) references address,
    CONSTRAINT purchase_fk_reference FOREIGN KEY(reference_price, reference_amount, reference_barcode) references prod_reference(price, amount, barcode),
    CONSTRAINT purchase_payment_type_fk FOREIGN KEY(payment_type) references payment_type(type),
    CONSTRAINT purchase_credit_card_fk FOREIGN KEY(credit_card_cardnum) references credit_card(cardnum),
    CONSTRAINT purchase_customer_fk FOREIGN KEY(customer_preferred_contact) references customer(preferred_contact)
);

CREATE INDEX address_per_client_town
    ON purchase(address_town, customer_preferred_contact);

