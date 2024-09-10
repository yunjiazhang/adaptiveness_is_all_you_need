SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
HashJoin(n pi ci rt t mi1 kt it1 it2)
NestLoop(n pi ci rt t mi1 kt it1)
NestLoop(n pi ci rt t mi1 kt)
NestLoop(n pi ci rt t mi1)
NestLoop(n pi ci rt t)
HashJoin(n pi ci rt)
NestLoop(n pi ci)
NestLoop(n pi)
IndexScan(mi1)
IndexScan(it1)
IndexScan(pi)
IndexScan(ci)
IndexScan(kt)
IndexScan(t)
SeqScan(it2)
SeqScan(rt)
SeqScan(n)
Leading(((((((((n pi) ci) rt) t) mi1) kt) it1) it2))
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
 AND (it1.id IN ('2','4')) 
 AND (it2.id IN ('19')) 
 AND (mi1.info IN ('English')) 
 AND (n.name ILIKE '%raffe%') 
 AND (kt.kind IN ('episode','movie','tv movie')) 
 AND (rt.role IN ('actress','composer','costume designer')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 GROUP BY mi1.info, n.name 
  
;