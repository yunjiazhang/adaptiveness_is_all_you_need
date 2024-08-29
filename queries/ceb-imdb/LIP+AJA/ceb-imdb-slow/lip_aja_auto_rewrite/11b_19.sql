SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%b%'::text) AND (mi1.info_type_id = 8)) AND ((mi1.info ~~* '%b%'::text) AND (mi1.info_type_id = 8));


/*+
HashJoin(pi n ci rt t mi1 mc cn ct kt it1 it2)
HashJoin(pi n ci rt t mi1 mc cn ct kt it1)
NestLoop(pi n ci rt t mi1 mc cn ct kt)
NestLoop(pi n ci rt t mi1 mc cn ct)
NestLoop(pi n ci rt t mi1 mc cn)
NestLoop(pi n ci rt t mi1 mc)
NestLoop(pi n ci rt t mi1)
NestLoop(pi n ci rt t)
NestLoop(pi n ci rt)
NestLoop(pi n ci)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
IndexScan(mc)
IndexScan(cn)
IndexScan(ct)
IndexScan(kt)
IndexScan(n)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
SeqScan(pi)
Leading((((((((((((pi n) ci) rt) t) mi1) mc) cn) ct) kt) it1) it2))
*/
 SELECT n.gender, 
        rt.role, 
        cn.name, 
        COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
movie_companies AS mc,
company_name AS cn,
company_type AS ct,
kind_type AS kt,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(0, ci.movie_id) 
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
   AND (kt.kind IN ('movie', 
                    'tv series', 
                    'video game', 
                    'video movie')) 
   AND (rt.role IN ('actor', 
                    'composer', 
                    'editor', 
                    'guest')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
   AND (it1.id IN ('8')) 
   AND (mi1.info ILIKE '%b%') 
   AND (pi.info ILIKE '%isbn%') 
   AND (it2.id IN ('29')) 
 GROUP BY n.gender, 
          rt.role, 
          cn.name 
 ORDER BY COUNT(*) DESC 
;