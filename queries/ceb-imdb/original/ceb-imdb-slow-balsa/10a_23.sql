SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('3','5'))
AND (mi1.info IN ('Canada:14A','Canada:G','Documentary','Germany:o.Al.','History','Ireland:12A','Peru:14','Philippines:G','Philippines:R-13','Spain:18','Sweden:15','UK:12','UK:A','USA:Approved','USA:G','USA:PG-13','USA:R','USA:TV-PG','Western'))
AND (n.name ILIKE '%mil%')
AND (kt.kind IN ('episode','movie','video movie'))
AND (rt.role IN ('actress','miscellaneous crew','producer'))
GROUP BY mi1.info, n.name
