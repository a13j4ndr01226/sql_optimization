/*
4.4
Write a SQL Query to find the top 10 authors publishing in journals and conferences
whose titles contain the word data. These will likely be some of the people at the
cutting edge of data science and data analytics. As a fun exercise, find a paper one of
them wrote that interests you and read it!
*/

with journals as
(/*unnest authors from journals*/
	select 
		trim(atr) as author
		,title
		
	from public.articles ar, 
		unnest(string_to_array(ar.author, '::')) as atr
	
	where 1=1
		and trim(lower(title)) like '%data%'
	
	order by 1,2
)
, conferences as
(/*unnest authors from conferences*/
	select
		trim(atr) as author
		,title
	
	from public.inproceedings ip,
		unnest(string_to_array(ip.author, ';')) as atr
	
	where 1=1
		and trim(lower(title)) like '%data%'
		
	order by 1,2
)
, j_and_c as 
(/*combines authors from both journals and conferences*/
	select * from journals
	
	union /*removes duplicates in both tables*/
	
	select * from conferences
)

select
	author
	,count(title) count_publications

from j_and_c 

group by 1

order by 2 desc

limit 10
