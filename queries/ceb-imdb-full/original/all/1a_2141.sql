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
AND (it1.id in ('8'))
AND (it2.id in ('1'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Argentina','Bulgaria','Czechoslovakia','Netherlands','USA'))
AND (mi2.info IN ('110','12','13','14','16','60','61','63','67','79','93','USA:20'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game'))
AND (rt.role in ('actress','costume designer','director','editor','production designer'))
AND (n.gender IN ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
