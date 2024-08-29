SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mc mi1 ci pi n rt t kt cn ct)
NestLoop(it1 mc mi1 ci pi n rt t kt cn ct)
HashJoin(mc mi1 ci pi n rt t kt cn ct)
HashJoin(mc mi1 ci pi n rt t kt cn)
HashJoin(mc mi1 ci pi n rt t kt)
HashJoin(mi1 ci pi n rt t kt)
HashJoin(mi1 ci pi n rt t)
HashJoin(ci pi n rt t)
HashJoin(ci pi n rt)
HashJoin(ci pi n)
HashJoin(pi n)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
SeqScan(mc)
SeqScan(ci)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(cn)
SeqScan(ct)
SeqScan(n)
SeqScan(t)
Leading((it2 (it1 (((mc ((mi1 (((ci (pi n)) rt) t)) kt)) cn) ct))))
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
                    'tv movie', 
                    'tv series', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('cinematographer', 
                    'composer', 
                    'costume designer', 
                    'guest', 
                    'producer')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1875) 
   AND (it1.id IN ('4')) 
   AND (mi1.info ILIKE '%n%') 
   AND (pi.info ILIKE '%19%') 
   AND (it2.id IN ('21')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;