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
AND (it1.id IN ('5'))
AND (mi1.info IN ('Canada:18+','Canada:A','Chile:Y7','Czech Republic:12','Denmark:A','France:-18','France:12','Hungary:16','India:U/A','Japan:R15+','Japan:U','Malaysia:18','Netherlands:Unrated','New Zealand:R13','Portugal:(Banned)','Singapore:R(A)','South Africa:13V','Taiwan:R-18','Venezuela:PG-13'))
AND (n.name ILIKE '%van%')
AND (kt.kind IN ('episode','movie','tv series'))
AND (rt.role IN ('director','miscellaneous crew','producer'))
GROUP BY mi1.info, n.name
