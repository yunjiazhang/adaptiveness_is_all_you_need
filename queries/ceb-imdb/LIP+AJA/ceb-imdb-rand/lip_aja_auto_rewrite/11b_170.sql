SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 ci pi n mi1 t kt rt mc cn ct)
NestLoop(it1 ci pi n mi1 t kt rt mc cn ct)
HashJoin(ci pi n mi1 t kt rt mc cn ct)
HashJoin(ci pi n mi1 t kt rt mc cn)
NestLoop(ci pi n mi1 t kt rt mc)
HashJoin(ci pi n mi1 t kt rt)
HashJoin(ci pi n mi1 t kt)
HashJoin(mi1 t kt)
HashJoin(ci pi n)
HashJoin(mi1 t)
HashJoin(pi n)
IndexScan(mc)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
SeqScan(ci)
SeqScan(pi)
SeqScan(kt)
SeqScan(rt)
SeqScan(cn)
SeqScan(ct)
SeqScan(n)
SeqScan(t)
Leading((it2 (it1 ((((((ci (pi n)) ((mi1 t) kt)) rt) mc) cn) ct))))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE 
 t.id = mc.movie_id 
 AND t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.movie_id = ci.movie_id 
 AND ci.movie_id = mc.movie_id 
 AND cn.id = mc.company_id 
 AND ct.id = mc.company_type_id 
 AND kt.id = t.kind_id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info_type_id = it1.id 
 AND n.id = pi.person_id 
 AND pi.info_type_id = it2.id 
 AND ci.person_id = pi.person_id 
 AND (kt.kind IN ('episode','movie','tv mini series','tv series','video movie')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer','director','editor','guest','miscellaneous crew','producer','writer')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1990) 
 AND (it1.id IN ('8')) 
 AND (mi1.info ILIKE '%ar%') 
 AND (pi.info ILIKE '%is%') 
 AND (it2.id IN ('20')) 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;