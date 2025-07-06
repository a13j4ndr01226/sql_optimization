/*
4.5
Write a SQL query to find the names of all conferences, happening in June, where the
proceedings contain more than 100 publications. Proceedings and inproceedings are
classified under conferences - according to the dblp website, so make sure you use both
tables and use the proper attribute year.
*/

with proceedings as
(/*unnest authors from journals*/
	select 
		booktitle
		,count(title) count_titles
		,'proceeding' as tbl
		
	from public.proceedings
		
	where 1=1
	
	group by 1
	
	order by 2 desc
)
, inproceedings as
(/*unnest authors from conferences*/
	select
		booktitle
		,count(title) as count_titles
		,'inproceeding' as tbl
	
	from public.inproceedings 
	
	where 1=1
	
	group by 1
		
	order by 1,2
)
, j_and_c as 
(/*combines authors from both journals and conferences*/
	select * from proceedings
	
	union /*removes duplicates in both tables*/
	
	select * from inproceedings
)

select booktitle
,sum(count_titles) total_publications

from j_and_c

group by 1

having sum(count_titles) > 100

order by 2 desc