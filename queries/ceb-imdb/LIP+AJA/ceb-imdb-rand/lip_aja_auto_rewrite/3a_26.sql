SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn 
        WHERE ((cn.country_code)::text = ANY ('{[cl],[co],[ee],[ir],[my],[pl],[xyu]}'::text[]));


/*+
NestLoop(k mk t kt mc ct cn ci rt n)
HashJoin(k mk t kt mc ct cn ci rt)
NestLoop(k mk t kt mc ct cn ci)
NestLoop(k mk t kt mc ct cn)
HashJoin(k mk t kt mc ct)
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
SeqScan(kt)
SeqScan(ct)
SeqScan(rt)
SeqScan(k)
Leading((((((((((k mk) t) kt) mc) ct) cn) ci) rt) n))
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
 AND t.production_year <= 1975 
 AND 1875 < t.production_year 
 AND k.keyword IN ('death','family-relationships','father-son-relationship','female-nudity','friendship','gay','hospital','husband-wife-relationship','male-nudity','mother-son-relationship','nudity','police','sequel','violence') 
 AND cn.country_code IN ('[cl]','[co]','[ee]','[ir]','[my]','[pl]','[xyu]') 
 AND ct.kind IN ('distributors','production companies') 
 AND kt.kind IN ('episode','tv movie') 
 AND rt.role IN ('miscellaneous crew','producer') 
 AND n.gender IN ('f','m') 
  
;