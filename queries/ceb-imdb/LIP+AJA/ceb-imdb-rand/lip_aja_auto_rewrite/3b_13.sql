SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, t.id)) FROM title AS t 
        WHERE (t.title ~~* '%of%'::text);
SELECT sum(pg_lip_bloom_add(1, n.id)) FROM name AS n 
        WHERE ((n.name_pcode_cf)::text ~~* '%h6%'::text);


/*+
NestLoop(mc cn t kt ci rt n ct mk k)
NestLoop(mc cn t kt ci rt n ct mk)
HashJoin(mc cn t kt ci rt n ct)
NestLoop(mc cn t kt ci rt n)
HashJoin(mc cn t kt ci rt)
NestLoop(mc cn t kt ci)
HashJoin(mc cn t kt)
NestLoop(mc cn t)
HashJoin(mc cn)
IndexScan(ci)
IndexScan(mk)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(mc)
SeqScan(cn)
SeqScan(kt)
SeqScan(rt)
SeqScan(ct)
Leading((((((((((mc cn) t) kt) ci) rt) n) ct) mk) k))
*/
 SELECT t.title, n.name, cn.name, COUNT(*) 
 
FROM 
title as t,
movie_keyword as mk,
keyword as k,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
company_name as cn,
company_type as ct,
kind_type as kt,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.person_id) 
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
 AND (t.title ILIKE '%of%') 
 AND (n.name_pcode_cf ILIKE '%h6%') 
 AND (cn.name ILIKE '%ch%') 
 AND (kt.kind IN ('episode','movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','actress','composer','costume designer','director','editor','producer','production designer','writer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;