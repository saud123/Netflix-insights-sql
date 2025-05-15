# 📊 Netflix Insights via SQL

![Netflix Logo](https://github.com/saud123/Netflix-insights-sql/blob/da15bd8289142d9c4801394bc83372196e08af77/image_2025-05-15_131818166.png?raw=true)


## 📊 Project Overview

This project performs **data analysis on Netflix's content catalog** using **SQL** to uncover key insights related to content type, ratings, duration, genres, and quality indicators.

The dataset includes thousands of titles categorized as Movies or TV Shows. The analysis answers key business questions using SQL queries in BigQuery.

## 🔍 Key Features

- Count and compare the number of **Movies vs. TV Shows**
- Identify the **most common content rating** across types (e.g., TV-MA)
- Find **shortest and longest content durations**
- Classify content as **"Good" or "Bad"** using keyword matching in descriptions
- Filter Netflix content by:
  - Specific **directors**
  - TV Shows with **more than 5 seasons**
  - **Action genre** titles
 
### Tools
- I used GoogleBigquery to analyze this dataset and uncover insights.

## 📌 SQL Use Cases Covered

### 1. Preview Sample Data

```sql
SELECT * 
FROM `static-entry-451116-t3.111.Netflix_table` 
LIMIT 1000;
```

### 2. 🎬 Count the Number of Movies and TV Shows
```
SELECT  
  type,
  COUNT(*) AS Number
FROM 
  `static-entry-451116-t3.111.Netflix_table`
GROUP BY 
  type;
```

### 3. ⭐ Identify Most Common Ratings by Type

```
WITH count_ratings AS (
  SELECT type, rating, COUNT(*) AS rating_count
  FROM `static-entry-451116-t3.111.Netflix_table`
  GROUP BY type, rating
),
Ranks AS (
  SELECT type, rating, rating_count,
  RANK() OVER(PARTITION BY type ORDER BY rating_count DESC) AS rank
  FROM count_ratings
)
SELECT type, rating
FROM Ranks
WHERE rank = 1;

```

### 4. ⏱️ Movie with Highest and Lowest Duration

```
(
  SELECT *, CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS duration_int
  FROM `static-entry-451116-t3.111.Netflix_table`
  WHERE type = 'Movie'
  ORDER BY duration_int DESC
  LIMIT 1
)
UNION ALL
(
  SELECT *, CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS duration_int
  FROM `static-entry-451116-t3.111.Netflix_table`
  WHERE type = 'Movie' AND duration IS NOT NULL
  ORDER BY duration_int ASC
  LIMIT 1
);

```

### 5. 📅Extract Netflix Titles in Action Genre--
```
Select *
FROM static-entry-451116-t3.111.Netflix_table
WHERE listed_in LIKE '%Action%';

```
### 6.  Filter All Movies/TV Shows by Director 'Rajiv Chilaka' --

```
SELECT type
FROM static-entry-451116-t3.111.Netflix_table
WHERE "Rajiv Chilaka" IN UNNEST(Split(director,","));
```

### 7. 🔫 List All TV Shows with More Than 5 Seasons 
```
WITH Seasons As (
SELECT type, title,
CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS season_number
FROM static-entry-451116-t3.111.Netflix_table
WHERE type = "TV Show"
)
Select * From Seasons
Where Seasons.season_number > 5
ORDER BY 3 DESC;
```


### 8  Categorize Content on "Good" Vs "Bad"

```
SELECT 
  category,
  COUNT(*) AS content_count
FROM (
  SELECT 
    IF(
      REGEXP_CONTAINS(LOWER(description), r'(kill|violence)'), 
      'Bad', 
      'Good'
    ) AS category
  FROM `static-entry-451116-t3.111.Netflix_table`
) AS categorized_content
GROUP BY category;
```


### 9  Finding Median Movie duration

```
SELECT
  PERCENTILE_CONT(duration_int, 0.5) OVER() AS median_movie_duration
FROM (
  SELECT
    CAST(SPLIT(duration, ' ')[OFFSET(0)] AS INT64) AS duration_int
  FROM `static-entry-451116-t3.111.Netflix_table`
  WHERE type = 'Movie' AND duration IS NOT NULL
);
```




### 📌 Insights & Recommendations:
#### Content Focus: 
With more movies (6131) than TV shows (2676) and most content rated TV-MA, Netflix should consider diversifying its rating distribution and investing in more family-friendly or youth-oriented content.

#### Duration Optimization: 
The median movie duration is 98 minutes, with the shortest being 3 minutes and the longest exceeding 5 hours (312 minutes). Netflix should consider maintaining or slightly shortening movie lengths to match user attention spans, and also invest in mid-length formats (60–90 mins) to optimize engagement and reduce drop-off rates.

#### Content Quality & Curation: 
Since most content (8465) is categorized as “Good”, Netflix should continue investing in high-quality productions while flagging or labeling violent-themed content (342) for better parental control and user filtering.




## ✅ Conclusion

This project showcases how SQL can be effectively used to extract meaningful insights from streaming data. By analyzing Netflix content, we identified trends in content type, duration, ratings, and themes — enabling data-driven recommendations for content strategy, user experience, and content moderation.




