SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%di%'::text) AND (mi1.info_type_id = 6)) AND ((mi1.info ~~* '%di%'::text) AND (mi1.info_type_id = 6));


/*+
NestLoop(it2 it1 pi n ci rt t kt mi1 mc cn ct)
NestLoop(it1 pi n ci rt t kt mi1 mc cn ct)
HashJoin(pi n ci rt t kt mi1 mc cn ct)
NestLoop(pi n ci rt t kt mi1 mc cn)
NestLoop(pi n ci rt t kt mi1 mc)
NestLoop(pi n ci rt t kt mi1)
HashJoin(pi n ci rt t kt)
NestLoop(pi n ci rt t)
HashJoin(pi n ci rt)
NestLoop(pi n ci)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(ci)
IndexScan(mc)
IndexScan(cn)
SeqScan(it2)
SeqScan(it1)
IndexScan(n)
IndexScan(t)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
Leading((it2 (it1 (((((((((pi n) ci) rt) t) kt) mi1) mc) cn) ct))))
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
 AND (kt.kind IN ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actress','cinematographer','costume designer','editor','miscellaneous crew','producer','writer')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1990) 
 AND (it1.id IN ('6')) 
 AND (mi1.info ILIKE '%di%') 
 AND (pi.info ILIKE '%neth%') 
 AND (it2.id IN ('37')) 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;