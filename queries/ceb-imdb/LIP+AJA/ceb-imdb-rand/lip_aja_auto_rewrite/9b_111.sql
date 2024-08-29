SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 t kt ci rt n pi)
NestLoop(it1 mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
HashJoin(t kt)
IndexScan(ci)
IndexScan(pi)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((it2 (it1 (((((mi1 (t kt)) ci) rt) n) pi))))
*/
 SELECT mi1.info, n.name, COUNT(*) 
 
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
 AND (it1.id IN ('8')) 
 AND (it2.id IN ('20')) 
 AND (mi1.info IN ('Australia','Austria','Belgium','Brazil','Canada','Denmark','East Germany','Finland','France','Italy','Mexico','Netherlands','Spain','UK','USA','Yugoslavia')) 
 AND (n.name ILIKE '%le%') 
 AND (kt.kind IN ('tv movie','tv series','video game')) 
 AND (rt.role IN ('cinematographer','composer','editor','writer')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 GROUP BY mi1.info, n.name 
  
;