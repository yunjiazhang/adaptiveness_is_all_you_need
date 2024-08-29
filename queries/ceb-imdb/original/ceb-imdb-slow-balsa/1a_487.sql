SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('18'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Acapulco, Guerrero, Mexico','Alabama Hills, Lone Pine, California, USA','Biograph Studio, Manhattan, New York City, New York, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Hamburg, Germany','Helsinki, Finland','Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA','Mexico City, Distrito Federal, Mexico','Philippines','Prague, Czech Republic','San Francisco, California, USA'))
AND (mi2.info IN ('Comedy','Documentary','Fantasy','History','Horror','Romance','Short','Sport'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video movie'))
AND (rt.role in ('editor','guest'))
AND (n.gender IN ('f'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
