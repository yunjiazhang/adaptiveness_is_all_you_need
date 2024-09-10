SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%19%'::text) AND (pi.info_type_id = 21));


/*+
NestLoop(it2 it1 mi1 t kt ci rt n pi)
NestLoop(it1 mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi1 t) kt) ci) rt) n) pi))))
*/
 SELECT mi1.info, 
        pi.info, 
        COUNT(*) 
 
FROM 
title AS t,
kind_type AS kt,
movie_info AS mi1,
info_type AS it1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id) 
) AS ci,
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
   AND (mi1.info ILIKE '%ko%') 
   AND (pi.info ILIKE '%19%') 
   AND (kt.kind IN ('movie', 
                    'tv mini series', 
                    'tv movie', 
                    'tv series', 
                    'video game')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'costume designer', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer', 
                    'writer')) 
 GROUP BY mi1.info, 
          pi.info 
;