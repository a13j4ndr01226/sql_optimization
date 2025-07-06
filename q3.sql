/*
4.3
Write a SQL Query to find the total number of conference publications for each
decade, starting from 1970 and ending in 2019. For instance, to find the total papers
from the 1970s you would sum the totals from 1970, 1971,1972...1978, up to 1979.
Please do this for the decades 1970, 1980, 1990, 2000, and 2010.
Hint: You may want to create a temporary table with all the distinct years.
*/
WITH decades AS (
  SELECT 
    year,
    (year / 10) * 10 AS decade
  FROM generate_series(1970, 2019) AS year
),
publications AS (
  SELECT 
    year,
    title
  FROM public.publications
)

SELECT 
  d.decade,
  COUNT(p.title) AS publication_count
FROM decades d
LEFT JOIN publications p
  ON CAST(d.year AS INT) = CAST(p.year AS INT)
GROUP BY d.decade
ORDER BY d.decade;
