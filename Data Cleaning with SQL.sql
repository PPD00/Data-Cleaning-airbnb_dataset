
-- Data Cleaning with SQL with airbnb dataset.

-- Here's structure of airbnb table:

CREATE TABLE details (
    s_no SERIAL PRIMARY KEY, -- Auto-incrementing serial number
    listing_id INT NOT NULL, 
    name VARCHAR(255),
    host_id INT,
    host_name VARCHAR(100),
    neighbourhood_full VARCHAR(255),
    coordinates POINT, -- Using POINT type for latitude and longitude
    room_type VARCHAR(50),
    price DECIMAL(10, 2), -- Adjust for price format, decimal used instead of $ sign
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month DECIMAL(4, 2), 
    availability_365 INT CHECK (availability_365 BETWEEN 0 AND 365),
    rating DECIMAL(5, 4), -- Supports precision to store ratings like 4.1009
    number_of_stays DECIMAL(6, 2),
    five_stars DECIMAL(10, 9), -- Supports a precision like 0.609431505
    listing_added DATE
);


SELECT *, data_type
FROM information_schema.columns
WHERE table_name = 'details'

select * from details
select COUNT(*) from details
-- Removing Duplicates

SELECT listing_id, COUNT(*) -- finding duplicates
FROM details
GROUP BY listing_id
HAVING COUNT(*) > 1;


SELECT * 
FROM details a
JOIN details b
ON a.listing_id = b.listing_id
AND a.s_no <> b.s_no

WITH duplicates AS (
SELECT 
 ctid, -- This is a unique row in PostgreSQL(systemcolumn)
ROW_NUMBER() OVER (PARTITION BY listing_id, host_id ORDER BY listing_id) as rn
FROM details
)

DELETE FROM details
WHERE ctid IN (
SELECT ctid FROM duplicates
WHERE rn > 1
) 


-- Handling Missing Values

-- 1st

SELECT COUNT(*)
FROM details
WHERE five_stars IS NULL

SELECT *
FROM details
WHERE price IS NULL

UPDATE details
SET last_review = '01-01-1900',
    number_of_stays = 0,
	rating = 0,
	five_stars = 0,
	price = 0
WHERE last_review IS NULL
  AND number_of_stays IS NULL
  AND rating IS NULL
  AND five_stars IS NULL
  AND price IS NULL


--2nd

SELECT * FROM details
WHERE name IS NULL
OR host_name IS null

DELETE FROM details
WHERE name IS NULL
OR host_name IS null



-- Removing Specific Columns

ALTER TABLE your_table
DROP COLUMN neighbourhood_full;