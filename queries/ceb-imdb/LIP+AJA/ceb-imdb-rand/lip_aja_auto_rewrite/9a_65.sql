SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%19%'::text) AND (pi.info_type_id = 23));


/*+
NestLoop(it2 it1 mi1 t ci rt pi n kt)
NestLoop(it1 mi1 t ci rt pi n kt)
HashJoin(mi1 t ci rt pi n kt)
NestLoop(mi1 t ci rt pi n)
NestLoop(mi1 t ci rt pi)
HashJoin(mi1 t ci rt)
NestLoop(mi1 t ci)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(rt)
SeqScan(kt)
Leading((it2 (it1 ((((((mi1 t) ci) rt) pi) n) kt))))
*/
 SELECT mi1.info, pi.info, COUNT(*) 
 
FROM 
title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id) 
) AS ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
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
 AND (it1.id IN ('106')) 
 AND (it2.id IN ('23')) 
 AND (mi1.info ILIKE '%199%') 
 AND (pi.info ILIKE '%19%') 
 AND (kt.kind IN ('episode','movie','tv mini series','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','miscellaneous crew','writer')) 
 GROUP BY mi1.info, pi.info 
  
;