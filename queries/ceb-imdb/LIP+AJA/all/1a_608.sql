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
AND (it1.id in ('4'))
AND (it2.id in ('5'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('American Sign Language','Cantonese','English','Irish Gaelic','Malay'))
AND (mi2.info IN ('Canada:14A','Iceland:14','New Zealand:R18','Norway:16','Norway:7','Portugal:M/12','Singapore:M18','South Korea:15','USA:TV-14','USA:TV-Y7'))
AND (kt.kind in ('episode','tv movie','tv series','video movie'))
AND (rt.role in ('costume designer','miscellaneous crew','producer','production designer','writer'))
AND (n.gender IN ('f','m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
