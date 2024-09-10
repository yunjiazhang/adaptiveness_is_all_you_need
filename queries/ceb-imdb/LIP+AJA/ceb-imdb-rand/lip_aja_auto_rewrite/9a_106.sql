SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 ci pi n rt t kt)
NestLoop(it1 mi1 ci pi n rt t kt)
HashJoin(mi1 ci pi n rt t kt)
NestLoop(mi1 ci pi n rt t)
HashJoin(mi1 ci pi n rt)
HashJoin(mi1 ci pi n)
HashJoin(ci pi n)
NestLoop(pi n)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
IndexScan(t)
SeqScan(ci)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
Leading((it2 (it1 ((((mi1 (ci (pi n))) rt) t) kt))))
*/
 SELECT mi1.info, pi.info, COUNT(*) 
 
FROM 
title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.info_type_id = it1.id 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.movie_id = mi1.movie_id 
 AND ci.role_id = rt.id 
 AND n.id = pi.person_id 
 AND pi.info_type_id = it2.id 
 AND (it1.id IN ('16')) 
 AND (it2.id IN ('23')) 
 AND (mi1.info ILIKE '%spa%') 
 AND (pi.info ILIKE '%19%') 
 AND (kt.kind IN ('tv mini series','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','editor','guest','producer','production designer','writer')) 
 GROUP BY mi1.info, pi.info 
  
;