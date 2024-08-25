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
AND (it2.id in ('2'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('CBS Studio 50, New York City, New York, USA','CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','Paris, France','Philippines','San Francisco, California, USA','Stage 7, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA'))
AND (mi2.info IN ('Black and White','Color'))
AND (kt.kind in ('episode','movie','tv movie','video game'))
AND (rt.role in ('composer','producer','production designer'))
AND (n.gender IN ('f') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
