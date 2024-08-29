SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, t.id)) FROM title AS t 
        WHERE (t.title ~~* '%br%'::text);


/*+
NestLoop(n ci rt t kt mc cn ct mk k)
NestLoop(n ci rt t kt mc cn ct mk)
NestLoop(n ci rt t kt mc cn ct)
NestLoop(n ci rt t kt mc cn)
NestLoop(n ci rt t kt mc)
NestLoop(n ci rt t kt)
NestLoop(n ci rt t)
HashJoin(n ci rt)
NestLoop(n ci)
IndexScan(ci)
IndexScan(kt)
IndexScan(mc)
IndexScan(cn)
IndexScan(ct)
IndexScan(mk)
IndexScan(t)
IndexScan(k)
SeqScan(rt)
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
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.movie_id) 
) AS ci,
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
 AND (t.title ILIKE '%br%') 
 AND (n.surname_pcode ILIKE '%j1%') 
 AND (cn.name ILIKE '%m%') 
 AND (kt.kind IN ('movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','composer','director','production designer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;