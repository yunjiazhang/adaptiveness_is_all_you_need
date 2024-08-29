SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 pi mi1 t kt ci rt n mc cn ct)
NestLoop(it1 pi mi1 t kt ci rt n mc cn ct)
HashJoin(pi mi1 t kt ci rt n mc cn ct)
NestLoop(pi mi1 t kt ci rt n mc cn)
NestLoop(pi mi1 t kt ci rt n mc)
NestLoop(pi mi1 t kt ci rt n)
HashJoin(pi mi1 t kt ci rt)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
HashJoin(t kt)
IndexScan(ci)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
SeqScan(pi)
SeqScan(kt)
SeqScan(rt)
SeqScan(ct)
SeqScan(t)
Leading((it2 (it1 (((((pi (((mi1 (t kt)) ci) rt)) n) mc) cn) ct))))
*/
 SELECT n.gender, 
        rt.role, 
        cn.name, 
        COUNT(*) 
 
FROM 
title AS t,
movie_companies AS mc,
company_name AS cn,
company_type AS ct,
kind_type AS kt,
cast_info AS ci,
name AS n,
role_type AS rt,
movie_info AS mi1,
info_type AS it1,
person_info AS pi,
info_type AS it2
WHERE 
 t.id = mc.movie_id 
   AND t.id = ci.movie_id 
   AND t.id = mi1.movie_id 
   AND mi1.movie_id = ci.movie_id 
   AND ci.movie_id = mc.movie_id 
   AND cn.id = mc.company_id 
   AND ct.id = mc.company_type_id 
   AND kt.id = t.kind_id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND mi1.info_type_id = it1.id 
   AND n.id = pi.person_id 
   AND pi.info_type_id = it2.id 
   AND ci.person_id = pi.person_id 
   AND (kt.kind IN ('movie', 
                    'tv movie', 
                    'video game')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'costume designer', 
                    'director', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'production designer')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1945) 
   AND (it1.id IN ('5')) 
   AND (mi1.info ILIKE '%t%') 
   AND (pi.info ILIKE '%sept%') 
   AND (it2.id IN ('21')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;