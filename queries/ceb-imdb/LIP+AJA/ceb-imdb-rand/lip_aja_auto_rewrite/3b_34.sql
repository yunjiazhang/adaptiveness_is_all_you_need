SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE ((n.name_pcode_cf)::text ~~* '%f65%'::text);


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
 AND (t.title ILIKE '%lisa%') 
 AND (n.name_pcode_cf ILIKE '%f65%') 
 AND (cn.name ILIKE '%d%') 
 AND (kt.kind IN ('movie','tv movie','tv series','video movie')) 
 AND (rt.role IN ('actor','actress','composer','director','editor','miscellaneous crew','producer','production designer','writer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;