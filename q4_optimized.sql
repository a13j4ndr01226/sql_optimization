
DROP TABLE IF EXISTS temp_art_con;

CREATE TEMP TABLE temp_art_con AS

-- Use CTEs to filter for 'Data' titles and unnest authors for each table
WITH article_authors AS (
    SELECT 
        TRIM(ar) AS author,
        a.title
    FROM (
        SELECT author, title
        FROM public.articles
        WHERE title ILIKE '%data%'
    ) a,
    UNNEST(string_to_array(a.author, '::')) AS ar
),
conference_authors AS (
    SELECT 
        TRIM(ar) AS author,
        ip.title
    FROM (
        SELECT author, title
        FROM public.inproceedings
        WHERE title ILIKE '%data%'
    ) ip,
    UNNEST(string_to_array(ip.author, ';')) AS ar
)

SELECT * FROM article_authors
UNION ALL
SELECT * FROM conference_authors;

Explain Analyze
select
	author
	,count(title) count_publications

from temp_art_con

group by 1

order by 2 desc

limit 10
