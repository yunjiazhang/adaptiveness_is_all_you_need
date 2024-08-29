SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE ((n.surname_pcode)::text ~~* '%l15%'::text);


/*+
NestLoop(mc cn t kt ci rt n ct mk k)
NestLoop(mc cn t kt ci rt n ct mk)
NestLoop(mc cn t kt ci rt n ct)
NestLoop(mc cn t kt ci rt n)
HashJoin(mc cn t kt ci rt)
NestLoop(mc cn t kt ci)
HashJoin(mc cn t kt)
NestLoop(mc cn t)
HashJoin(mc cn)
IndexScan(ci)
IndexScan(ct)
IndexScan(mk)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(mc)
SeqScan(cn)
SeqScan(kt)
SeqScan(rt)
Leading((((((((((mc cn) t) kt) ci) rt) n) ct) mk) k))
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
 AND (t.title ILIKE '%in%') 
 AND (n.surname_pcode ILIKE '%l15%') 
 AND (cn.name ILIKE '%tele%') 
 AND (kt.kind IN ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','actress','composer','costume designer','editor','miscellaneous crew','producer','production designer','writer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;