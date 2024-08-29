SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 mi2 t kt ci rt n)
NestLoop(it1 mi1 mi2 t kt ci rt n)
HashJoin(mi1 mi2 t kt ci rt n)
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
 AND mi1.info IN ('Belgium','Brazil','Germany','India','Mexico','Netherlands','Romania','Soviet Union','Taiwan','Turkey','USA') 
 AND mi2.info IN ('Dutch','English','German','Malayalam','Mandarin','Portuguese','Romanian','Russian','Spanish','Turkish') 
 AND kt.kind IN ('episode','movie','video movie') 
 AND rt.role IN ('director','miscellaneous crew') 
 AND n.gender IN ('m') 
 AND t.production_year <= 2015 
 AND 1925 < t.production_year 
  
;