SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it mi1 mc cn t ct kt ci rt n)
NestLoop(mi1 mc cn t ct kt ci rt n)
HashJoin(mi1 mc cn t ct kt ci rt)
NestLoop(mi1 mc cn t ct kt ci)
HashJoin(mi1 mc cn t ct kt)
HashJoin(mi1 mc cn t ct)
NestLoop(mi1 mc cn t)
HashJoin(mi1 mc cn)
HashJoin(mc cn)
IndexScan(ci)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(it)
SeqScan(mc)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
SeqScan(rt)
Leading((it (((((((mi1 (mc cn)) t) ct) kt) ci) rt) n)))
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
 AND (rt.role IN ('actor','composer','costume designer','editor','miscellaneous crew','producer','production designer','writer')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1875) 
 AND (it.id IN ('5')) 
 AND (mi1.info ILIKE '%m%') 
 AND (cn.name ILIKE '%and%') 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;