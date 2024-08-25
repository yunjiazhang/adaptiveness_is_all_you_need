SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('4'))
AND (it2.id in ('18'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('English','Spanish'))
AND (mi2.info in ('Buenos Aires, Federal District, Argentina','CBS Studio 50, New York City, New York, USA','CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA','Los Angeles, California, USA','Mexico City, Distrito Federal, Mexico','Stage 3, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA'))
AND (kt.kind in ('tv series','video game'))
AND (rt.role in ('costume designer','editor'))
AND (n.gender in ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
