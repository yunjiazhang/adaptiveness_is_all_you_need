SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it mi1 t mc cn ct kt ci rt n)
HashJoin(mi1 t mc cn ct kt ci rt n)
HashJoin(mi1 t mc cn ct kt ci rt)
NestLoop(mi1 t mc cn ct kt ci)
HashJoin(mi1 t mc cn ct kt)
HashJoin(mi1 t mc cn ct)
HashJoin(mi1 t mc cn)
NestLoop(mi1 t mc)
HashJoin(mi1 t)
IndexScan(mc)
IndexScan(ci)
SeqScan(mi1)
IndexScan(n)
SeqScan(it)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((it ((((((((mi1 t) mc) cn) ct) kt) ci) rt) n)))
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
   AND (kt.kind ILIKE '%v%') 
   AND (rt.role IN ('actress', 
                    'cinematographer', 
                    'composer', 
                    'director', 
                    'editor', 
                    'guest', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer', 
                    'writer')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1945) 
   AND (it.id IN ('5')) 
   AND (mi1.info ILIKE '%r%') 
   AND (cn.name ILIKE '%te%') 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;