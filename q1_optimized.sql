/*Create temp table with year as int to use in index*/

DROP TABLE IF EXISTS inproceedings_v2;

CREATE TEMP TABLE inproceedings_v2 AS
SELECT 
	DISTINCT CAST(year AS INT) as year_int
	,booktitle
	
FROM inproceedings

WHERE CAST(year AS INT) = 2018 ;

/*Create Index*/
CREATE INDEX idx_ip2018_booktitle 
ON inproceedings_v2(booktitle);

explain analyze

with benchmarked_conferences as
(/*Fitlers for conferences that have published at least 200 papers in 1 decade*/
	SELECT  
		booktitle
		,min(cast(year as int)) as first_year
		,max(cast(year as int)) as latest_year
		,max(cast(year as int)) - min(cast(year as int)) as active_years
		,count(*) as count_papers
		,count(*)/(max(cast(year as int)) - min(cast(year as int)))  avg_papers_per_year
		
	FROM public.inproceedings
	
	where 1=1
		
	group by booktitle
	
	having count(*)/(max(cast(year as int)) - min(cast(year as int))) >= 20
		and (max(cast(year as int)) - min(cast(year as int))) >= 10
)

select 
	ip.year_int
	,ip.booktitle

FROM inproceedings_v2 ip

inner join benchmarked_conferences bc
	on ip.booktitle = bc.booktitle
;