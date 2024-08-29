SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE ((pi.info ~~* '%er%'::text) AND (pi.info_type_id = 26));


/*+
NestLoop(it2 it1 mi1 t kt ci rt pi n)
NestLoop(it1 mi1 t kt ci rt pi n)
NestLoop(mi1 t kt ci rt pi n)
NestLoop(mi1 t kt ci rt pi)
HashJoin(mi1 t kt ci rt)
NestLoop(mi1 t kt ci)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(ci)
IndexScan(pi)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi1 t) kt) ci) rt) pi) n))))
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
 AND (it1.id IN ('107')) 
 AND (it2.id IN ('26')) 
 AND (mi1.info ILIKE '%mar%') 
 AND (pi.info ILIKE '%er%') 
 AND (kt.kind IN ('episode','movie','tv movie','video game')) 
 AND (rt.role IN ('cinematographer','costume designer','director','editor','production designer','writer')) 
 GROUP BY mi1.info, pi.info 
  
;