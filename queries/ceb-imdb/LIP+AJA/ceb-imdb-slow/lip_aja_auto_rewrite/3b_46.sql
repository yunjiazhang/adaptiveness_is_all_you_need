SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
HashJoin(mc t cn kt ci n rt ct mk k)
NestLoop(mc t cn kt ci n rt ct mk)
HashJoin(mc t cn kt ci n rt ct)
HashJoin(mc t cn kt ci n rt)
HashJoin(mc t cn kt ci n)
NestLoop(mc t cn kt ci)
HashJoin(mc t cn kt)
HashJoin(mc t cn)
HashJoin(mc t)
IndexScan(ci)
IndexScan(mk)
SeqScan(mc)
SeqScan(cn)
SeqScan(kt)
SeqScan(rt)
SeqScan(ct)
SeqScan(t)
SeqScan(n)
SeqScan(k)
Leading((((((((((mc t) cn) kt) ci) n) rt) ct) mk) k))
*/
 SELECT t.title, 
        n.name, 
        cn.name, 
        COUNT(*) 
 
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
   AND (t.title ILIKE '%an%') 
   AND (n.name_pcode_cf ILIKE '%w4%') 
   AND (cn.name ILIKE '%e%') 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie', 
                    'tv series', 
                    'video game')) 
   AND (rt.role IN ('actor', 
                    'cinematographer', 
                    'composer', 
                    'director', 
                    'editor', 
                    'miscellaneous crew', 
                    'producer', 
                    'writer')) 
 GROUP BY t.title, 
          n.name, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;