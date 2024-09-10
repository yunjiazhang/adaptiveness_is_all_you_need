SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
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
AND it1.id = '3'
AND it2.id = '5'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Adult','Comedy','Drama','Music','Romance','Thriller','War')
AND mi2.info IN ('Australia:PG','Finland:K-16','Sweden:15','Sweden:Btl','USA:Approved','USA:Not Rated','USA:Passed','USA:TV-G','USA:X','West Germany:12','West Germany:18')
AND kt.kind IN ('tv series','video game')
AND rt.role IN ('costume designer','director')
AND n.gender IN ('f')
AND t.production_year <= 1975
AND 1875 < t.production_year