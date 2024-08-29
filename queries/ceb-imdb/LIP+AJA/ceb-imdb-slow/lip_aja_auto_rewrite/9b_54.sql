SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE (n.name ~~* '%ver%'::text);
SELECT sum(pg_lip_bloom_add(1, pi.person_id)) FROM person_info AS pi 
        WHERE (pi.info_type_id = 24);


/*+
NestLoop(it2 mi1 it1 t kt ci rt n pi)
NestLoop(mi1 it1 t kt ci rt n pi)
HashJoin(mi1 it1 t kt ci rt n)
HashJoin(mi1 it1 t kt ci rt)
NestLoop(mi1 it1 t kt ci)
HashJoin(mi1 it1 t kt)
NestLoop(mi1 it1 t)
HashJoin(mi1 it1)
IndexScan(ci)
IndexScan(pi)
SeqScan(it2)
SeqScan(mi1)
SeqScan(it1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (((((((mi1 it1) t) kt) ci) rt) n) pi)))
*/
 SELECT mi1.info, 
        n.name, 
        COUNT(*) 
 
FROM 
title AS t,
kind_type AS kt,
movie_info AS mi1,
info_type AS it1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id)  AND pg_lip_bloom_probe(1, ci.person_id) 
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
   AND (it1.id IN ('2', 
                   '4', 
                   '6')) 
   AND (it2.id IN ('24')) 
   AND (mi1.info IN ('70 mm 6-Track', 
                     'Black AND White', 
                     'Color', 
                     'Czech', 
                     'Dolby', 
                     'Dutch', 
                     'English', 
                     'French', 
                     'German', 
                     'Hindi', 
                     'Hungarian', 
                     'Italian', 
                     'Norwegian', 
                     'Portuguese', 
                     'Russian', 
                     'Spanish')) 
   AND (n.name ILIKE '%ver%') 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'costume designer')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
 GROUP BY mi1.info, 
          n.name 
;