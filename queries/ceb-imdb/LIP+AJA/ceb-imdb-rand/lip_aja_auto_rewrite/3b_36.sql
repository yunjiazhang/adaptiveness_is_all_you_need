SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn 
        WHERE (cn.name ~~* '%pic%'::text);


/*+
NestLoop(t kt mk mc cn ci rt n k ct)
NestLoop(t kt mk mc cn ci rt n k)
NestLoop(t kt mk mc cn ci rt n)
HashJoin(t kt mk mc cn ci rt)
NestLoop(t kt mk mc cn ci)
NestLoop(t kt mk mc cn)
NestLoop(t kt mk mc)
NestLoop(t kt mk)
HashJoin(t kt)
IndexScan(mk)
IndexScan(mc)
IndexScan(cn)
IndexScan(ci)
IndexScan(ct)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((((((((((t kt) mk) mc) cn) ci) rt) n) k) ct))
*/
 SELECT t.title, n.name, cn.name, COUNT(*) 
 
FROM 
title as t,
movie_keyword as mk,
keyword as k,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.company_id) 
) AS mc,
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
 AND (t.title ILIKE '%hir%') 
 AND (n.name_pcode_nf ILIKE '%m%') 
 AND (cn.name ILIKE '%pic%') 
 AND (kt.kind IN ('episode','movie','tv series','video game','video movie')) 
 AND (rt.role IN ('costume designer','miscellaneous crew','producer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;