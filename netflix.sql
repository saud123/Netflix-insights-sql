
-- File: netflix_analysis.sql

-- 0. View Sample Data --
SELECT * 
FROM `static-entry-451116-t3.111.Netflix_table` 
LIMIT 1000;


-- 1. Count the Number of Movies and TV Shows --
SELECT  
  type,
  COUNT(*) AS Number
FROM 
  `static-entry-451116-t3.111.Netflix_table`
GROUP BY 
  type;


-- 2. Identify Most Common Rating for Movies and TV Shows --
WITH count_ratings AS (
  SELECT 
    type, 
    rating,
    COUNT(*) AS rating_count
  FROM  
    `static-entry-451116-t3.111.Netflix_table`
  GROUP BY 
    type, rating
), Ranks AS (
  SELECT 
    type, 
    rating, 
    rating_count,
    RANK() OVER(PARTITION BY type ORDER BY rating_count DESC) AS rank
  FROM 
    count_ratings
)
SELECT 
  type, 
  rating
FROM 
  Ranks
WHERE 
  rank = 1;


-- 3. Movie with Highest and Lowest Duration --
(
  SELECT
    *,
    CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS duration_int
  FROM 
    `static-entry-451116-t3.111.Netflix_table`
  WHERE 
    type = 'Movie'
  ORDER BY 
    duration_int DESC
  LIMIT 1
)
UNION ALL
(
  SELECT
    *,
    CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS duration_int
  FROM 
    `static-entry-451116-t3.111.Netflix_table`
  WHERE 
    type = 'Movie'
    AND duration IS NOT NULL
  ORDER BY 
    duration_int ASC
  LIMIT 1
);


-- 4. Find Content From Last 5 Years --
SELECT * 
FROM `static-entry-451116-t3.111.Netflix_table`
WHERE release_year >= EXTRACT(YEAR FROM CURRENT_DATE()) - 5;


-- 5. Filter All Movies/TV Shows by Director 'Rajiv Chilaka' --
SELECT 
  type
FROM 
  `static-entry-451116-t3.111.Netflix_table`
WHERE 
  "Rajiv Chilaka" IN UNNEST(SPLIT(director, ","));


-- 6. Extract Netflix Titles in Action Genre --
SELECT *
FROM 
  `static-entry-451116-t3.111.Netflix_table`
WHERE 
  listed_in LIKE '%Action%';


-- 7. List All TV Shows with More Than 5 Seasons --
WITH Seasons AS (
  SELECT 
    type, 
    title,
    CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS season_number
  FROM 
    `static-entry-451116-t3.111.Netflix_table`
  WHERE 
    type = 'TV Show'
)
SELECT * 
FROM 
  Seasons
WHERE 
  season_number > 5
ORDER BY 
  season_number DESC;
