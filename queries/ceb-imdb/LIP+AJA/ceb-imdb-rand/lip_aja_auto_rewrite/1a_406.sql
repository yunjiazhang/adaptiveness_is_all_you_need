SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 mi2 t kt ci rt n)
NestLoop(it1 mi1 mi2 t kt ci rt n)
NestLoop(mi1 mi2 t kt ci rt n)
HashJoin(mi1 mi2 t kt ci rt)
NestLoop(mi1 mi2 t kt ci)
HashJoin(mi1 mi2 t kt)
NestLoop(mi1 mi2 t)
HashJoin(mi1 mi2)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
SeqScan(mi2)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi1 mi2) t) kt) ci) rt) n))))
*/
 SELECT COUNT(*) 
FROM 
title as t,
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
 AND it1.id = '8' 
 AND it2.id = '4' 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info IN ('Albania','Cuba','Czechoslovakia','Finland','France','Germany','Hong Kong','Mexico','South Africa','Switzerland','USA') 
 AND mi2.info IN ('Albanian','Czech','English','French','Italian','Mandarin','Spanish') 
 AND kt.kind IN ('tv movie','tv series','video game') 
 AND rt.role IN ('composer','director') 
 AND n.gender IN ('f') 
 AND t.production_year <= 2015 
 AND 1975 < t.production_year 
  
;