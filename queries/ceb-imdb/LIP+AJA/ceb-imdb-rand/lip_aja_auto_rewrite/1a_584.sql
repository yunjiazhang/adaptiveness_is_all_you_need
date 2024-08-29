SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi2 mi1 t kt ci rt n)
NestLoop(it1 mi2 mi1 t kt ci rt n)
NestLoop(mi2 mi1 t kt ci rt n)
HashJoin(mi2 mi1 t kt ci rt)
NestLoop(mi2 mi1 t kt ci)
HashJoin(mi2 mi1 t kt)
NestLoop(mi2 mi1 t)
HashJoin(mi2 mi1)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi2)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi2 mi1) t) kt) ci) rt) n))))
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
 AND it1.id = '3' 
 AND it2.id = '7' 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info IN ('Animation','Biography','Drama','Family','Musical','Romance','Short','Thriller') 
 AND mi2.info IN ('CAM:Canon 7D','CAM:Panavision Cameras AND Lenses','LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','OFM:35 mm','PCS:Digital Intermediate','PFM:35 mm','PFM:Video','RAT:1.33 : 1','RAT:1.78 : 1','RAT:1.85 : 1','RAT:2.35 : 1') 
 AND kt.kind IN ('tv movie','tv series','video game') 
 AND rt.role IN ('composer','producer') 
 AND n.gender IN ('m') 
 AND t.production_year <= 2015 
 AND 1975 < t.production_year 
  
;