SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%el%'::text) AND (pi.info_type_id = 20));


/*+
NestLoop(it2 it1 mi1 t kt ci rt pi n mc cn ct)
NestLoop(it1 mi1 t kt ci rt pi n mc cn ct)
HashJoin(mi1 t kt ci rt pi n mc cn ct)
NestLoop(mi1 t kt ci rt pi n mc cn)
NestLoop(mi1 t kt ci rt pi n mc)
NestLoop(mi1 t kt ci rt pi n)
NestLoop(mi1 t kt ci rt pi)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
SeqScan(ct)
Leading((it2 (it1 (((((((((mi1 t) kt) ci) rt) pi) n) mc) cn) ct))))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id) 
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
 AND (kt.kind IN ('episode','movie','tv mini series','tv movie','tv series','video movie')) 
 AND (rt.role IN ('actor','actress','miscellaneous crew','producer')) 
 AND (t.production_year <= 1945) 
 AND (t.production_year >= 1875) 
 AND (it1.id IN ('8')) 
 AND (mi1.info ILIKE '%fr%') 
 AND (pi.info ILIKE '%el%') 
 AND (it2.id IN ('20')) 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;