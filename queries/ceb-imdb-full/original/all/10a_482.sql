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
AND (it1.id IN ('3','5','8'))
AND (mi1.info IN ('Belgium:KT','Denmark:11','Finland:K-13','Germany:o.Al.','Hong Kong:IIA','Iceland','Iceland:14','Ireland:15','Ireland:15A','Malaysia:18','Mexico:B15','Norway:7','Philippines:G','Singapore:G','Singapore:R(A)','Singapore:R21','South Korea'))
AND (n.name ILIKE '%mars%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('director','miscellaneous crew','producer','production designer'))
GROUP BY mi1.info, n.name
