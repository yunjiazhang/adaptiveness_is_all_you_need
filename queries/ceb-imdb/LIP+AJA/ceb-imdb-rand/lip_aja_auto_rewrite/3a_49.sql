SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn 
        WHERE ((cn.country_code)::text = ANY ('{[nl],[sg]}'::text[]));


/*+
NestLoop(rt kt k mk t mc ct cn ci n)
NestLoop(rt kt k mk t mc ct cn ci)
NestLoop(kt k mk t mc ct cn ci)
NestLoop(kt k mk t mc ct cn)
HashJoin(kt k mk t mc ct)
NestLoop(kt k mk t mc)
NestLoop(kt k mk t)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mk)
IndexScan(mc)
IndexScan(cn)
IndexScan(ci)
IndexScan(t)
IndexScan(n)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
SeqScan(k)
Leading(((rt (((((kt ((k mk) t)) mc) ct) cn) ci)) n))
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
 AND t.production_year <= 2015 
 AND 1900 < t.production_year 
 AND k.keyword IN ('dancing','flashback') 
 AND cn.country_code IN ('[nl]','[sg]') 
 AND ct.kind IN ('distributors','production companies') 
 AND kt.kind IN ('episode') 
 AND rt.role IN ('actor') 
 AND n.gender IN ('m') 
  
;