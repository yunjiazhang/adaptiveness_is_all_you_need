SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
HashJoin(k mk t kt mc ct cn ci rt n)
HashJoin(k mk t kt mc ct cn ci rt)
NestLoop(k mk t kt mc ct cn ci)
HashJoin(k mk t kt mc ct cn)
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
movie_companies as mc,
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
 AND (t.production_year >= 1975) 
 AND (k.keyword IN ('blood','father-daughter-relationship','gay','husband-wife-relationship','independent-film','lesbian','lesbian-sex','male-frontal-nudity','male-nudity','nudity','sex','singer')) 
 AND (cn.country_code IN ('[fi]','[ie]','[it]','[us]')) 
 AND (ct.kind IN ('distributors','production companies')) 
 AND (kt.kind IN ('episode','movie','video movie')) 
 AND (rt.role IN ('composer','producer')) 
 AND (n.gender IN ('m')) 
  
;