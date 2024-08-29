SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%192%'::text) AND (pi.info_type_id = 23));


/*+
HashJoin(mi1 t kt ci rt pi n it1 it2)
HashJoin(mi1 t kt ci rt pi n it1)
NestLoop(mi1 t kt ci rt pi n)
NestLoop(mi1 t kt ci rt pi)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
SeqScan(rt)
Leading(((((((((mi1 t) kt) ci) rt) pi) n) it1) it2))
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
 AND (it1.id IN ('16')) 
 AND (it2.id IN ('23')) 
 AND (mi1.info ILIKE '%ko%') 
 AND (pi.info ILIKE '%192%') 
 AND (kt.kind IN ('episode','movie','tv mini series','tv movie')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer','director','editor','miscellaneous crew','producer','production designer','writer')) 
 GROUP BY mi1.info, pi.info 
  
;