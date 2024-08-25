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
AND (it1.id in ('3'))
AND (it2.id in ('5'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Adventure','Comedy','Crime','Documentary','Drama','Family','Romance','Sci-Fi'))
AND (mi2.info in ('Australia:G','Australia:PG','Hong Kong:III','Iceland:L','Malaysia:U','Portugal:M/12','Singapore:PG','Sweden:7','Switzerland:10','UK:15','UK:U'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('director','editor'))
AND (n.gender in ('f','m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
