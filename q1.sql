/*
4.1
Write a SQL Query to find all the conferences held in 2018 that have published at least
200 papers in a single decade.
Please note, conferences may be annual conferences, such as KDD. Each year a
different number of conferences are held. You should list conferences multiple times if
they appear in multiple years.

*/

with benchmarked_conferences as
(/*Fitlers for conferences that have published at least 200 papers in 1 decade*/
	SELECT  
		booktitle
		,min(cast(year as int)) as first_year
		,max(cast(year as int)) as latest_year
		,max(cast(year as int)) - min(cast(year as int)) as active_years
		,count(title) as count_papers
		,count(title)/(max(cast(year as int)) - min(cast(year as int)))  avg_papers_per_year
	
	FROM public.inproceedings
	
	where 1=1
		
	group by booktitle
	
	having (count(title)/(max(cast(year as int)) - min(cast(year as int)))) >= 20 
		and (max(cast(year as int)) - min(cast(year as int))) >= 10
	
	order by avg_papers_per_year, count_papers, active_years
)


select distinct
	ip.year
	,ip.booktitle

FROM public.inproceedings ip

inner join benchmarked_conferences bc
	on ip.booktitle = bc.booktitle

where 1=1
	and ip.year = '2018';
