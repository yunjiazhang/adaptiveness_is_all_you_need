SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 t ci pi n rt kt mc cn ct)
NestLoop(it1 mi1 t ci pi n rt kt mc cn ct)
HashJoin(mi1 t ci pi n rt kt mc cn ct)
NestLoop(mi1 t ci pi n rt kt mc cn)
NestLoop(mi1 t ci pi n rt kt mc)
HashJoin(mi1 t ci pi n rt kt)
HashJoin(mi1 t ci pi n rt)
HashJoin(mi1 t ci pi n)
NestLoop(mi1 t ci)
HashJoin(mi1 t)
NestLoop(pi n)
IndexScan(ci)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
SeqScan(t)
Leading((it2 (it1 ((((((((mi1 t) ci) (pi n)) rt) kt) mc) cn) ct))))
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
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv mini series', 
                    'tv movie', 
                    'tv series', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'composer', 
                    'costume designer', 
                    'director', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1945) 
   AND (it1.id IN ('6')) 
   AND (mi1.info ILIKE '%d%') 
   AND (pi.info ILIKE '%%') 
   AND (it2.id IN ('37')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;