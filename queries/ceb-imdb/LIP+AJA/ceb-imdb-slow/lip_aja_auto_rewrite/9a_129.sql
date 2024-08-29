SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 pi mi1 t kt ci rt n)
NestLoop(it1 pi mi1 t kt ci rt n)
NestLoop(pi mi1 t kt ci rt n)
HashJoin(pi mi1 t kt ci rt)
HashJoin(pi mi1 t kt ci)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(pi)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 (((pi (((mi1 t) kt) ci)) rt) n))))
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
   AND (it1.id IN ('7')) 
   AND (it2.id IN ('38')) 
   AND (mi1.info ILIKE '%pfm%') 
   AND (pi.info ILIKE '%by%') 
   AND (kt.kind IN ('movie', 
                    'tv movie', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'cinematographer', 
                    'composer', 
                    'director', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer', 
                    'writer')) 
 GROUP BY mi1.info, 
          pi.info 
;