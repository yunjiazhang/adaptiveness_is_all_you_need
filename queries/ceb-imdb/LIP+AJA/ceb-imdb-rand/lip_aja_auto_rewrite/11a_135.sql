SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(mi1 t mc cn ct kt it ci rt n)
HashJoin(mi1 t mc cn ct kt it ci rt)
NestLoop(mi1 t mc cn ct kt it ci)
HashJoin(mi1 t mc cn ct kt it)
NestLoop(mi1 t mc cn ct kt)
NestLoop(mi1 t mc cn ct)
NestLoop(mi1 t mc cn)
NestLoop(mi1 t mc)
NestLoop(mi1 t)
IndexScan(mc)
IndexScan(cn)
IndexScan(ct)
IndexScan(kt)
IndexScan(ci)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(it)
SeqScan(rt)
Leading((((((((((mi1 t) mc) cn) ct) kt) it) ci) rt) n))
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
info_type as it
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
 AND mi1.info_type_id = it.id 
 AND (kt.kind ILIKE '%m%') 
 AND (rt.role IN ('actress','costume designer','guest','miscellaneous crew')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1990) 
 AND (it.id IN ('6')) 
 AND (mi1.info ILIKE '%sdd%') 
 AND (cn.name ILIKE '%fil%') 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;