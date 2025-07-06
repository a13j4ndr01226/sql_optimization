DROP TABLE IF EXISTS proceedings_v2;
DROP TABLE IF EXISTS inproceedings_v2;
DROP TABLE IF EXISTS combined;

CREATE TEMP TABLE proceedings_v2 AS
SELECT booktitle, COUNT(title) AS count_titles
FROM public.proceedings
GROUP BY booktitle;

CREATE TEMP TABLE inproceedings_v2 AS
SELECT booktitle, COUNT(title) AS count_titles
FROM public.inproceedings
GROUP BY booktitle;

CREATE TEMP TABLE combined AS
SELECT * FROM proceedings_v2
UNION ALL
SELECT * FROM inproceedings_v2;

Explain Analyze

select booktitle
,sum(count_titles) total_publications

from combined

group by 1

having sum(count_titles) > 100

order by 2 desc
