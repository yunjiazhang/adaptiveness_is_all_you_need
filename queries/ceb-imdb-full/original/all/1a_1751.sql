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
AND (it1.id in ('7'))
AND (it2.id in ('6'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('CAM:Panavision Panaflex Platinum, Panavision Primo Lenses','LAB:EFILM Digital Laboratories, Hollywood (CA), USA','LAB:Technicolor, USA','PCS:Panavision','RAT:1.78 : 1','RAT:1.85 : 1'))
AND (mi2.info IN ('4-Track Stereo','DTS','DTS-Stereo','Datasat','Dolby Digital EX','Dolby','Mono','Silent','Sonics-DDP','Stereo'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('cinematographer','director','editor'))
AND (n.gender IN ('m') OR n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
