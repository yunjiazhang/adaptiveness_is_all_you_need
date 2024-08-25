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
AND (it1.id in ('7'))
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('OFM:16 mm','OFM:Video','PCS:Digital Intermediate','PCS:Spherical','PFM:70 mm','RAT:1.66 : 1','RAT:2.35 : 1'))
AND (mi2.info in ('Germany','India','Italy','Japan','UK','USA','West Germany'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('actress','costume designer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (k.keyword IN ('bare-breasts','bare-chested-male','dancing','father-son-relationship','female-frontal-nudity','flashback','hospital','jealousy','kidnapping','lesbian-sex','male-frontal-nudity','male-nudity','non-fiction','party','surrealism'))
