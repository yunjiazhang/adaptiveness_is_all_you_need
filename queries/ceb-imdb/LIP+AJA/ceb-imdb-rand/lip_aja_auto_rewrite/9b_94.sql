SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, pi.person_id)) FROM person_info AS pi 
        WHERE (pi.info_type_id = 33);


/*+
HashJoin(mi1 it1 t kt ci rt n pi it2)
NestLoop(mi1 it1 t kt ci rt n pi)
NestLoop(mi1 it1 t kt ci rt n)
HashJoin(mi1 it1 t kt ci rt)
NestLoop(mi1 it1 t kt ci)
NestLoop(mi1 it1 t kt)
NestLoop(mi1 it1 t)
HashJoin(mi1 it1)
IndexScan(kt)
IndexScan(ci)
IndexScan(pi)
SeqScan(mi1)
SeqScan(it1)
IndexScan(t)
IndexScan(n)
SeqScan(it2)
SeqScan(rt)
Leading(((((((((mi1 it1) t) kt) ci) rt) n) pi) it2))
*/
 SELECT mi1.info, n.name, COUNT(*) 
 
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
 AND (it1.id IN ('2','4')) 
 AND (it2.id IN ('33')) 
 AND (mi1.info IN ('Afrikaans','Albanian','American Sign Language','Azeri','Cantonese','Catalan','Estonian','Georgian','Hebrew','Korean','Mandarin','Persian','Slovenian','Swiss German','Ukrainian','Urdu')) 
 AND (n.name ILIKE '%ro%') 
 AND (kt.kind IN ('episode','movie','video movie')) 
 AND (rt.role IN ('actress','costume designer','director','miscellaneous crew','producer')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 GROUP BY mi1.info, n.name 
  
;