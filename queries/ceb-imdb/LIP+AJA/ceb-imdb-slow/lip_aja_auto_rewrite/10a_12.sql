SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE (n.name ~~* '%mark%'::text);


/*+
NestLoop(it1 mi1 t kt ci rt n)
HashJoin(mi1 t kt ci rt n)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it1 (((((mi1 t) kt) ci) rt) n)))
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
   AND (it1.id IN ('6')) 
   AND (mi1.info IN ('DTS', 
                     'Dolby Digital', 
                     'Dolby SR', 
                     'Dolby', 
                     'Mono', 
                     'SDDS', 
                     'Silent', 
                     'Stereo')) 
   AND (n.name ILIKE '%mark%') 
   AND (kt.kind IN ('episode', 
                    'movie')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'cinematographer', 
                    'costume designer')) 
 GROUP BY mi1.info, 
          n.name 
;