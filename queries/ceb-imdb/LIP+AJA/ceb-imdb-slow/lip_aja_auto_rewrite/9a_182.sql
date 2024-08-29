SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 ci pi n rt t kt)
NestLoop(it1 mi1 ci pi n rt t kt)
HashJoin(mi1 ci pi n rt t kt)
HashJoin(mi1 ci pi n rt t)
HashJoin(mi1 ci pi n rt)
HashJoin(ci pi n rt)
HashJoin(ci pi n)
HashJoin(pi n)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
SeqScan(ci)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(n)
Leading((it2 (it1 (((mi1 ((ci (pi n)) rt)) t) kt))))
*/
 SELECT mi1.info, 
        pi.info, 
        COUNT(*) 
 
FROM 
title AS t,
kind_type AS kt,
movie_info AS mi1,
info_type AS it1,
cast_info AS ci,
role_type AS rt,
name AS n,
info_type AS it2,
person_info AS pi
WHERE 
 t.id = ci.movie_id 
   AND t.id = mi1.movie_id 
   AND mi1.info_type_id = it1.id 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.movie_id = mi1.movie_id 
   AND ci.role_id = rt.id 
   AND n.id = pi.person_id 
   AND pi.info_type_id = it2.id 
   AND (it1.id IN ('16')) 
   AND (it2.id IN ('21')) 
   AND (mi1.info ILIKE '%em%') 
   AND (pi.info ILIKE '%19%') 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie', 
                    'tv series', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('actor', 
                    'cinematographer', 
                    'costume designer', 
                    'director', 
                    'editor', 
                    'miscellaneous crew', 
                    'producer', 
                    'writer')) 
 GROUP BY mi1.info, 
          pi.info 
;