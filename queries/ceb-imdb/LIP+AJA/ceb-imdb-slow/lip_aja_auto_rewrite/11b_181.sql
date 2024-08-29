SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 ci pi n rt t kt mc cn ct)
NestLoop(it1 mi1 ci pi n rt t kt mc cn ct)
HashJoin(mi1 ci pi n rt t kt mc cn ct)
NestLoop(mi1 ci pi n rt t kt mc cn)
NestLoop(mi1 ci pi n rt t kt mc)
HashJoin(mi1 ci pi n rt t kt)
NestLoop(mi1 ci pi n rt t)
HashJoin(mi1 ci pi n rt)
HashJoin(ci pi n rt)
HashJoin(ci pi n)
NestLoop(pi n)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
IndexScan(t)
SeqScan(ci)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
Leading((it2 (it1 ((((((mi1 ((ci (pi n)) rt)) t) kt) mc) cn) ct))))
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
                    'tv mini series', 
                    'tv series', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('actress', 
                    'costume designer', 
                    'director', 
                    'guest', 
                    'producer', 
                    'production designer')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
   AND (it1.id IN ('5')) 
   AND (mi1.info ILIKE '%:%') 
   AND (pi.info ILIKE '%us%') 
   AND (it2.id IN ('39')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;