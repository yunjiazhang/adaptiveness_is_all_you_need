SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%of%'::text) AND (mi1.info_type_id = 16));


/*+
NestLoop(it2 it1 pi n ci rt mi1 t kt)
NestLoop(it1 pi n ci rt mi1 t kt)
NestLoop(pi n ci rt mi1 t kt)
NestLoop(pi n ci rt mi1 t)
NestLoop(pi n ci rt mi1)
HashJoin(pi n ci rt)
NestLoop(pi n ci)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(ci)
IndexScan(kt)
SeqScan(it2)
SeqScan(it1)
IndexScan(n)
IndexScan(t)
SeqScan(pi)
SeqScan(rt)
Leading((it2 (it1 ((((((pi n) ci) rt) mi1) t) kt))))
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
pg_lip_bloom_probe(0, ci.movie_id) 
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
 AND (it1.id IN ('16')) 
 AND (it2.id IN ('21')) 
 AND (mi1.info ILIKE '%of%') 
 AND (pi.info ILIKE '%24%') 
 AND (kt.kind IN ('episode','movie','tv mini series','tv movie','tv series','video game','video movie')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','editor','guest','miscellaneous crew','producer','writer')) 
 GROUP BY mi1.info, pi.info 
  
;