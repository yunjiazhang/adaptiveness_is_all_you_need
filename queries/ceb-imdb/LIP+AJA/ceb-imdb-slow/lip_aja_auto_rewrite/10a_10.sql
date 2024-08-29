SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE (n.name ~~* '%rich%'::text);


/*+
HashJoin(mi1 it1 t kt ci rt n)
HashJoin(mi1 it1 t kt ci rt)
NestLoop(mi1 it1 t kt ci)
HashJoin(mi1 it1 t kt)
NestLoop(mi1 it1 t)
HashJoin(mi1 it1)
IndexScan(ci)
SeqScan(mi1)
SeqScan(it1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading(((((((mi1 it1) t) kt) ci) rt) n))
*/
 SELECT n.name, 
        mi1.info, 
        MIN(t.production_year), 
        MAX(t.production_year) 
 
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
name AS n
WHERE 
 t.id = ci.movie_id 
   AND t.id = mi1.movie_id 
   AND mi1.info_type_id = it1.id 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.movie_id = mi1.movie_id 
   AND ci.role_id = rt.id 
   AND (it1.id IN ('4', 
                   '5', 
                   '6')) 
   AND (mi1.info IN ('70 mm 6-Track', 
                     'Australia:R', 
                     'Czech', 
                     'Datasat', 
                     'English', 
                     'France:-12', 
                     'Germany:16', 
                     'Hong Kong:IIA', 
                     'Russian', 
                     'USA:TV-PG')) 
   AND (n.name ILIKE '%rich%') 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('actress', 
                    'costume designer', 
                    'director', 
                    'miscellaneous crew', 
                    'producer')) 
 GROUP BY mi1.info, 
          n.name 
;