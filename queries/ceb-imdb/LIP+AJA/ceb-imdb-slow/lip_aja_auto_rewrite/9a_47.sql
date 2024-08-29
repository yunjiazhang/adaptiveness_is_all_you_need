SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%usa%'::text) AND (mi1.info_type_id = 106)) AND ((mi1.info ~~* '%usa%'::text) AND (mi1.info_type_id = 106));


/*+
NestLoop(it2 it1 pi n ci rt t kt mi1)
NestLoop(it1 pi n ci rt t kt mi1)
NestLoop(pi n ci rt t kt mi1)
HashJoin(pi n ci rt t kt)
NestLoop(pi n ci rt t)
HashJoin(pi n ci rt)
NestLoop(pi n ci)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
IndexScan(n)
IndexScan(t)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
Leading((it2 (it1 ((((((pi n) ci) rt) t) kt) mi1))))
*/
 SELECT mi1.info, 
        pi.info, 
        COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type AS kt,
movie_info AS mi1,
info_type AS it1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
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
   AND (it1.id IN ('106')) 
   AND (it2.id IN ('38')) 
   AND (mi1.info ILIKE '%usa%') 
   AND (pi.info ILIKE '%pla%') 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv mini series', 
                    'tv movie', 
                    'tv series', 
                    'video movie')) 
   AND (rt.role IN ('actress', 
                    'director', 
                    'editor', 
                    'miscellaneous crew', 
                    'producer')) 
 GROUP BY mi1.info, 
          pi.info 
;