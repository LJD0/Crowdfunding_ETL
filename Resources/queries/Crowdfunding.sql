
-- Create the Crowdfunding Database
CREATE DATABASE "Crowdfunding"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Create the category table
CREATE TABLE category
(
    category_id VARCHAR NOT NULL,
    category VARCHAR NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE (category_id)
);

-- Create the subcategory table
CREATE TABLE subcategory
(
    subcategory_id VARCHAR NOT NULL,
    subcategory VARCHAR NOT NULL,
    PRIMARY KEY (subcategory_id),
    UNIQUE (subcategory_id)
);

-- Create the contacts table
CREATE TABLE contacts
(
    contact_id INT NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    PRIMARY KEY (contact_id)

);

-- Create the campaign table
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

-- Create the backers table
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

-- Create a "live_projects" table that has the names, and email and the amount left to reach the goal for all "live" projects.
CREATE TABLE live_projects (
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    amount_left NUMERIC(10,2)
);

-- Create a table, "email_backers_remaining_goal_amount" 
CREATE TABLE email_backers_remaining_goal_amount (
    email VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    cf_id INT,
    company_name VARCHAR,
    description TEXT,
    end_date DATE,
    "Left of Goal" NUMERIC(10,2)
);


-- build the live projects table
INSERT INTO live_projects (first_name, last_name, email, amount_left)
SELECT c.first_name, c.last_name, c.email, (cam.goal - cam.pledged) AS amount_left
FROM contacts AS c
INNER JOIN campaign AS cam ON c.contact_id = cam.contact_id
WHERE cam.outcome = 'live'
ORDER BY amount_left DESC;
-- Check the table
SELECT * FROM live_projects;


-- build the email_backers_remaining_goal_amount table
INSERT INTO email_backers_remaining_goal_amount (email, first_name, last_name, cf_id, company_name, description, end_date, "Left of Goal")
SELECT b.email, b.first_name, b.last_name, c.cf_id, c.company_name, c.descriptions, c.end_date, (c.goal - c.pledged) AS "Left of Goal"
FROM backers b
INNER JOIN campaign c ON b.cf_id = c.cf_id
ORDER BY b.email DESC;
-- Check the table
SELECT * FROM email_backers_remaining_goal_amount;


-- Retrieve all the number of backer_counts in descending order. 
SELECT backers.cf_id, COUNT(*) AS backer_counts
FROM backers
INNER JOIN campaign ON backers.cf_id = campaign.cf_id
WHERE outcome = 'live'
GROUP BY backers.cf_id
ORDER BY backer_counts DESC;