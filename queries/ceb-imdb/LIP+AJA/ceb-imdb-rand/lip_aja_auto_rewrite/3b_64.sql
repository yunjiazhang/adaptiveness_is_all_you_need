SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(n ci rt t kt mc cn ct mk k)
NestLoop(n ci rt t kt mc cn ct mk)
HashJoin(n ci rt t kt mc cn ct)
NestLoop(n ci rt t kt mc cn)
NestLoop(n ci rt t kt mc)
HashJoin(n ci rt t kt)
NestLoop(n ci rt t)
HashJoin(n ci rt)
NestLoop(n ci)
IndexScan(ci)
IndexScan(mc)
IndexScan(cn)
IndexScan(mk)
IndexScan(t)
IndexScan(k)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
SeqScan(n)
Leading((((((((((n ci) rt) t) kt) mc) cn) ct) mk) k))
*/
 SELECT t.title, n.name, cn.name, COUNT(*) 
 
FROM 
title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE 
 t.id = mk.movie_id 
 AND t.id = mc.movie_id 
 AND t.id = ci.movie_id 
 AND ci.movie_id = mc.movie_id 
 AND ci.movie_id = mk.movie_id 
 AND mk.movie_id = mc.movie_id 
 AND k.id = mk.keyword_id 
 AND cn.id = mc.company_id 
 AND ct.id = mc.company_type_id 
 AND kt.id = t.kind_id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (t.title ILIKE '%ou%') 
 AND (n.name_pcode_cf ILIKE '%s43%') 
 AND (cn.name ILIKE '%d%') 
 AND (kt.kind IN ('movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','cinematographer','composer','editor','producer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;