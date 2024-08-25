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
AND (it2.id IN ('34'))
AND (mi1.info IN ('Belgium:KT','Canada:14+','Canada:18+','Canada:A','Chile:TE','Denmark:15','Denmark:7','Finland:K-13','Finland:K-18','Iceland:14','India:A','Japan:R-15','Netherlands:18','New Zealand:PG','Norway:12','UK:A','USA:TV-G','USA:X'))
AND (n.name ILIKE '%bea%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('director','editor','miscellaneous crew','producer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name
