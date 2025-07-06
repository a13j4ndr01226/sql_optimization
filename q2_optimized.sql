DROP TABLE IF EXISTS inproceedings_v2;

CREATE TEMP TABLE inproceedings_v2 AS
	SELECT
		ip.author
		,ip.title
		,ip.booktitle
	  ,case when TRIM(LOWER(ip.booktitle)) LIKE '%vldb%' then 'VLDB'
		when TRIM(LOWER(ip.booktitle)) LIKE '%sigmod%' then 'SIGMOD' end as type_
	
	FROM public.inproceedings ip

	WHERE (trim(lower(ip.booktitle)) like '%vldb%'
				or trim(lower(ip.booktitle)) like '%sigmod%');

-- Explain Analyze

WITH unnest_authors as 
( 
	SELECT
		trim(ar) as author
		,ip2.title
		,ip2.booktitle
		,ip2.type_
		
	FROM inproceedings_v2 ip2,
	  UNNEST(string_to_array(ip2.author, ';')) AS ar
	
	WHERE trim(ar) is not null
)

select author
	,count(case when type_ like 'VLDB' then title end) vldb_count
	,count(case when type_ like 'SIGMOD' then title end) sigmod_count

from unnest_authors

where 1=1

group by 1

having count(case when type_ like 'VLDB' then title end) >= 10
	and count(case when type_ like 'SIGMOD' then title end) >= 10

order by 1;