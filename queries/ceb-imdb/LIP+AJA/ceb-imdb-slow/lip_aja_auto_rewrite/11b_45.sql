SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%bri%'::text) AND (pi.info_type_id = 26));


/*+
NestLoop(it2 it1 mi1 t ci rt pi n mc cn ct kt)
NestLoop(it1 mi1 t ci rt pi n mc cn ct kt)
NestLoop(mi1 t ci rt pi n mc cn ct kt)
NestLoop(mi1 t ci rt pi n mc cn ct)
NestLoop(mi1 t ci rt pi n mc cn)
NestLoop(mi1 t ci rt pi n mc)
NestLoop(mi1 t ci rt pi n)
NestLoop(mi1 t ci rt pi)
HashJoin(mi1 t ci rt)
NestLoop(mi1 t ci)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
IndexScan(mc)
IndexScan(cn)
IndexScan(ct)
IndexScan(kt)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(rt)
Leading((it2 (it1 (((((((((mi1 t) ci) rt) pi) n) mc) cn) ct) kt))))
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
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id) 
) AS ci,
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
   AND (rt.role IN ('actress', 
                    'cinematographer', 
                    'composer', 
                    'costume designer', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer', 
                    'writer')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
   AND (it1.id IN ('6')) 
   AND (mi1.info ILIKE '%dol%') 
   AND (pi.info ILIKE '%bri%') 
   AND (it2.id IN ('26')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;