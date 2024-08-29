SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%dts%'::text) AND (mi1.info_type_id = 6));


/*+
HashJoin(mc cn mi1 t ct kt ci n rt it)
NestLoop(mc cn mi1 t ct kt ci n rt)
NestLoop(mc cn mi1 t ct kt ci n)
NestLoop(mc cn mi1 t ct kt ci)
NestLoop(mc cn mi1 t ct kt)
NestLoop(mc cn mi1 t ct)
NestLoop(mc cn mi1 t)
NestLoop(mc cn mi1)
HashJoin(mc cn)
IndexScan(mi1)
IndexScan(ct)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
IndexScan(t)
IndexScan(n)
SeqScan(mc)
SeqScan(cn)
SeqScan(it)
Leading((((((((((mc cn) mi1) t) ct) kt) ci) n) rt) it))
*/
 SELECT n.gender, 
        rt.role, 
        cn.name, 
        COUNT(*) 
 
FROM 
title AS t,
(
    SELECT * FROM movie_companies AS mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
company_name AS cn,
company_type AS ct,
kind_type AS kt,
cast_info AS ci,
name AS n,
role_type AS rt,
movie_info AS mi1,
info_type AS it
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
   AND mi1.info_type_id = it.id 
   AND (kt.kind ILIKE '%m%') 
   AND (rt.role IN ('actress', 
                    'cinematographer', 
                    'composer', 
                    'costume designer', 
                    'editor', 
                    'miscellaneous crew', 
                    'production designer')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1875) 
   AND (it.id IN ('6')) 
   AND (mi1.info ILIKE '%dts%') 
   AND (cn.name ILIKE '%wa%') 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;