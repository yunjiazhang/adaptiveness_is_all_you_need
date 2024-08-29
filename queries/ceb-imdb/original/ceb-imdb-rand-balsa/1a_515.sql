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
AND (it1.id in ('2'))
AND (it2.id in ('1'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Black and White','Color'))
AND (mi2.info IN ('120','28','36','40','52','54','65','94','UK:60','USA:2','USA:9'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('actress','composer'))
AND (n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
