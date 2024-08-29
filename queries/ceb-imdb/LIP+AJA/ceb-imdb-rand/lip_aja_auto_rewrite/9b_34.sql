SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE (n.name ~~* '%lo%'::text);
SELECT sum(pg_lip_bloom_add(1, pi.person_id)) FROM person_info AS pi 
        WHERE (pi.info_type_id = 26);


/*+
NestLoop(it2 it1 mi1 t kt ci rt n pi)
NestLoop(it1 mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n pi)
NestLoop(mi1 t kt ci rt n)
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
Leading((it2 (it1 ((((((mi1 t) kt) ci) rt) n) pi))))
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
pg_lip_bloom_probe(0, ci.person_id)  AND pg_lip_bloom_probe(1, ci.person_id) 
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
 AND (it1.id IN ('8')) 
 AND (it2.id IN ('26')) 
 AND (mi1.info IN ('Australia','Austria','East Germany','Finland','France','Italy','Netherlands','Sweden','UK','West Germany','Yugoslavia')) 
 AND (n.name ILIKE '%lo%') 
 AND (kt.kind IN ('episode','tv movie','video game')) 
 AND (rt.role IN ('actress','costume designer','producer')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 GROUP BY mi1.info, n.name 
  
;