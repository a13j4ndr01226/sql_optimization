/*
4.2 

Write a SQL Query to find all the authors who published at least 10 PVLDB papers and
at least 10 SIGMOD papers. You may need to do some legwork here to see how the
DBLP spells the names of various conferences and journals.
*/
with authors as (	
	SELECT 
	  TRIM(ar) AS author
	  ,ip.title
	  ,ip.booktitle
	  ,case when TRIM(LOWER(ip.booktitle)) LIKE '%vldb%' then 'VLDB'
	    	when TRIM(LOWER(ip.booktitle)) LIKE '%sigmod%' then 'SIGMOD' end as type_
	  
	FROM public.inproceedings ip,
	  UNNEST(string_to_array(ip.author, ';')) AS ar
	  
	WHERE TRIM(ar) IS NOT NULL
	  AND (
	    TRIM(LOWER(ip.booktitle)) LIKE '%vldb%'
	    OR TRIM(LOWER(ip.booktitle)) LIKE '%sigmod%')
)

select author
	,count(case when type_ like 'VLDB' then title end) vldb_count
	,count(case when type_ like 'SIGMOD' then title end) sigmod_count

from authors

where 1=1

group by 1

having count(case when type_ like 'VLDB' then title end) >= 10
	and count(case when type_ like 'SIGMOD' then title end) >= 10

order by 1