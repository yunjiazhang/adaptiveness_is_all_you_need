SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi2 mi1 t kt ci rt n mk k)
NestLoop(it1 mi2 mi1 t kt ci rt n mk k)
NestLoop(mi2 mi1 t kt ci rt n mk k)
NestLoop(mi2 mi1 t kt ci rt n mk)
NestLoop(mi2 mi1 t kt ci rt n)
HashJoin(mi2 mi1 t kt ci rt)
NestLoop(mi2 mi1 t kt ci)
HashJoin(mi2 mi1 t kt)
NestLoop(mi2 mi1 t)
HashJoin(mi2 mi1)
IndexScan(ci)
IndexScan(mk)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi2)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((((mi2 mi1) t) kt) ci) rt) n) mk) k))))
*/
 SELECT COUNT(*) 
FROM 
title as t,
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
 AND (it1.id in ('4')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Dutch','English','French','German','Italian','Korean','Spanish')) 
 AND (mi2.info in ('PCS:Redcode RAW','PCS:Spherical','PFM:35 mm','RAT:1.33 : 1','RAT:16:9 HD','RAT:2.35 : 1')) 
 AND (kt.kind in ('tv movie','tv series','video game')) 
 AND (rt.role in ('production designer','writer')) 
 AND (n.gender in ('f')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
  
;