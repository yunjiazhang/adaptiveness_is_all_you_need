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
AND (it1.id in ('5'))
AND (it2.id in ('2'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Argentina:13','Argentina:16','Canada:G','Finland:K-18','Spain:13','UK:15','USA:X'))
AND (mi2.info IN ('Black and White','Color'))
AND (kt.kind in ('movie','tv movie','tv series'))
AND (rt.role in ('actress','director','miscellaneous crew','writer'))
AND (n.gender IN ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (t.title in ('(#1.113)','Borderline','For Love or Money','Is There Sex After Death?','Jailbreak','Little Egypt','The Condemned','The Last Man','The Matchmakers','The Song of Bernadette','Vendetta'))
