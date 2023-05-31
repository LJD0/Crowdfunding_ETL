-- Active: 1666248580896@@localhost@5432@crowdfunding_db

CREATE TABLE campaign
(
    cf_id INT not null,
    contact_id INT not null,
    company_name VARCHAR(100) not null,
    descriptions TEXT not null,
    goal NUMERIC(10,2) not null,
    pledged NUMERIC(10,2) not null,
    outcome VARCHAR not null,
    backers_count INT,
    country VARCHAR not null,
    currency VARCHAR not null,
    launched_date DATE not null,
    end_date DATE not null,
    category_id VARCHAR not null,
    subcategory_id VARCHAR not null,
    FOREIGN KEY (category_id) REFERENCES category (category_id),
    FOREIGN KEY (subcategory_id) REFERENCES subcategory (subcategory_id),
    FOREIGN KEY (contact_id) REFERENCES contacts (contact_id),

    PRIMARY KEY (cf_id)
);

CREATE TABLE category
(
    category_id VARCHAR NOT NULL,
    category VARCHAR NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE (category_id)
);

CREATE TABLE contacts
(
    contact_id INT NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    PRIMARY KEY (contact_id)

);

CREATE TABLE subcategory
(
    subcategory_id VARCHAR NOT NULL,
    subcategory VARCHAR NOT NULL,
    PRIMARY KEY (subcategory_id),
    UNIQUE (subcategory_id)
);

CREATE TABLE backers
(
    backer_id VARCHAR NOT NULL,
    cf_id INT NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULl,
    PRIMARY KEY (backer_id),
    FOREIGN KEY (cf_id) REFERENCES campaign (cf_id)
);