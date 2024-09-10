SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn 
        WHERE ((cn.country_code)::text = '[lu]'::text);


/*+
NestLoop(ct k mk t kt mc cn ci rt n)
HashJoin(ct k mk t kt mc cn ci rt)
NestLoop(ct k mk t kt mc cn ci)
NestLoop(ct k mk t kt mc cn)
NestLoop(ct k mk t kt mc)
NestLoop(k mk t kt mc)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mk)
IndexScan(mc)
IndexScan(cn)
IndexScan(ci)
IndexScan(t)
IndexScan(n)
SeqScan(ct)
SeqScan(kt)
SeqScan(rt)
SeqScan(k)
Leading((((((ct ((((k mk) t) kt) mc)) cn) ci) rt) n))
*/
 SELECT COUNT(*) 
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
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
 AND (k.keyword IN ('husband-wife-relationship','non-fiction','oral-sex','surrealism')) 
 AND (cn.country_code IN ('[lu]')) 
 AND (ct.kind IN ('production companies')) 
 AND (kt.kind IN ('episode','movie','video movie')) 
 AND (rt.role IN ('cinematographer','costume designer')) 
 AND (n.gender IN ('f')) 
  
;