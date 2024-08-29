SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
HashJoin(rt k mk t kt mc ct cn ci n)
NestLoop(rt k mk t kt mc ct cn ci)
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
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
SeqScan(k)
Leading(((rt (((((((k mk) t) kt) mc) ct) cn) ci)) n))
*/
 SELECT COUNT(*) 
 
FROM 
title AS t,
movie_keyword AS mk,
keyword AS k,
movie_companies AS mc,
company_name AS cn,
company_type AS ct,
kind_type AS kt,
cast_info AS ci,
name AS n,
role_type AS rt
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
   AND (t.production_year >= 1900) 
   AND (k.keyword IN ('female-nudity', 
                      'hardcore', 
                      'non-fiction', 
                      'number-in-title')) 
   AND (cn.country_code IN ('[de]', 
                            '[fr]', 
                            '[mx]', 
                            '[ph]', 
                            '[us]')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('miscellaneous crew')) 
   AND (n.gender IN ('m')) 
;