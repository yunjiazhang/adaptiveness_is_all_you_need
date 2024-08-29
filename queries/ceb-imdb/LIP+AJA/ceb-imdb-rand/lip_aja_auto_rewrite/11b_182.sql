SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%e%'::text) AND (mi1.info_type_id = 4)) AND ((mi1.info ~~* '%e%'::text) AND (mi1.info_type_id = 4));


/*+
NestLoop(it2 it1 ci pi n rt t kt mi1 mc cn ct)
NestLoop(it1 ci pi n rt t kt mi1 mc cn ct)
HashJoin(ci pi n rt t kt mi1 mc cn ct)
NestLoop(ci pi n rt t kt mi1 mc cn)
NestLoop(ci pi n rt t kt mi1 mc)
NestLoop(ci pi n rt t kt mi1)
HashJoin(ci pi n rt t kt)
NestLoop(ci pi n rt t)
HashJoin(ci pi n rt)
HashJoin(ci pi n)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
IndexScan(n)
IndexScan(t)
SeqScan(ci)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
Leading((it2 (it1 ((((((((ci (pi n)) rt) t) kt) mi1) mc) cn) ct))))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.movie_id) 
) AS ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
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
 AND (kt.kind IN ('episode','movie','tv movie','tv series','video game')) 
 AND (rt.role IN ('composer','producer','writer')) 
 AND (t.production_year <= 1945) 
 AND (t.production_year >= 1875) 
 AND (it1.id IN ('4')) 
 AND (mi1.info ILIKE '%e%') 
 AND (pi.info ILIKE '%ma%') 
 AND (it2.id IN ('26')) 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;