SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE ((n.name_pcode_nf)::text ~~* '%j45%'::text);


/*+
NestLoop(t kt mc cn ci rt n ct mk k)
NestLoop(t kt mc cn ci rt n ct mk)
NestLoop(t kt mc cn ci rt n ct)
NestLoop(t kt mc cn ci rt n)
HashJoin(t kt mc cn ci rt)
NestLoop(t kt mc cn ci)
NestLoop(t kt mc cn)
NestLoop(t kt mc)
HashJoin(t kt)
IndexScan(mc)
IndexScan(cn)
IndexScan(ci)
IndexScan(ct)
IndexScan(mk)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((((((((((t kt) mc) cn) ci) rt) n) ct) mk) k))
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
pg_lip_bloom_probe(0, ci.person_id) 
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
 AND (t.title ILIKE '%gra%') 
 AND (n.name_pcode_nf ILIKE '%j45%') 
 AND (cn.name ILIKE '%r%') 
 AND (kt.kind IN ('episode','movie','tv series','video movie')) 
 AND (rt.role IN ('actress','cinematographer','composer','costume designer','editor','miscellaneous crew','producer','production designer','writer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;