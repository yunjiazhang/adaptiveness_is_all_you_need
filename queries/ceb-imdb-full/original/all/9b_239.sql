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
AND (it1.id IN ('3','5','6'))
AND (it2.id IN ('22'))
AND (mi1.info IN ('Australia:R','Crime','Family','Finland:S','Iceland:16','Netherlands:14','Netherlands:AL','Stereo','USA:Not Rated','USA:R','USA:X'))
AND (n.name ILIKE '%pe%')
AND (kt.kind IN ('episode','movie','video movie'))
AND (rt.role IN ('composer','editor','production designer','writer'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
GROUP BY mi1.info, n.name
