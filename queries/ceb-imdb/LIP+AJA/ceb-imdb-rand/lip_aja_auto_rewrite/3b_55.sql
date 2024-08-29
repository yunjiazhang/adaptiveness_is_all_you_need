SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, t.id)) FROM title AS t 
        WHERE (t.title ~~* '%ca%'::text);


/*+
NestLoop(cn mc t kt ci rt n ct mk k)
NestLoop(cn mc t kt ci rt n ct mk)
NestLoop(cn mc t kt ci rt n ct)
NestLoop(cn mc t kt ci rt n)
HashJoin(cn mc t kt ci rt)
NestLoop(cn mc t kt ci)
NestLoop(cn mc t kt)
NestLoop(cn mc t)
NestLoop(cn mc)
IndexScan(mc)
IndexScan(kt)
IndexScan(ci)
IndexScan(ct)
IndexScan(mk)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(rt)
Leading((((((((((cn mc) t) kt) ci) rt) n) ct) mk) k))
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
 AND (t.title ILIKE '%ca%') 
 AND (n.name_pcode_nf ILIKE '%s%') 
 AND (cn.name ILIKE '%j.%') 
 AND (kt.kind IN ('episode','tv movie','video game','video movie')) 
 AND (rt.role IN ('actor','director','editor','producer','production designer','writer')) 
 GROUP BY t.title, n.name, cn.name 
 ORDER BY COUNT(*) DESC 
  
;