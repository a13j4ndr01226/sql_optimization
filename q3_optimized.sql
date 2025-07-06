DROP TABLE IF EXISTS publications_v2;

CREATE TEMP TABLE publications_v2 AS
	SELECT 
    cast(year as int) year_int,
    title
  FROM public.publications

  WHERE CAST(year as int) between 1970 and 2019;

-- Explain Analyze

WITH decades AS (
  SELECT 
    year,
    (year / 10) * 10 AS decade
  FROM generate_series(1970, 2019) AS year
)

SELECT 
  d.decade,
  COUNT(p.title) AS publication_count
FROM decades d
LEFT JOIN publications_v2 p
  ON d.year = p.year_int
GROUP BY d.decade
ORDER BY d.decade;
