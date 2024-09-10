SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('2','3','5'))
AND (it2.id IN ('26'))
AND (mi1.info IN ('Argentina:Atp','Canada:G','Canada:PG','Comedy','Documentary','Finland:K-8','Horror','Iceland:12','Iceland:16','Mystery','Netherlands:14','Norway:18','Singapore:PG','Spain:T','UK:PG','USA:Not Rated','USA:TV-G','War'))
AND (n.name ILIKE '%na%')
AND (kt.kind IN ('episode','movie','video game'))
AND (rt.role IN ('costume designer','director','miscellaneous crew'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name