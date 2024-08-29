SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%©20%'::text) AND (mi1.info_type_id = 103)) AND ((mi1.info ~~* '%©20%'::text) AND (mi1.info_type_id = 103));


/*+
HashJoin(pi n ci rt t kt mi1 it1 it2)
NestLoop(pi n ci rt t kt mi1 it1)
NestLoop(pi n ci rt t kt mi1)
HashJoin(pi n ci rt t kt)
NestLoop(pi n ci rt t)
HashJoin(pi n ci rt)
NestLoop(pi n ci)
NestLoop(pi n)
IndexScan(mi1)
IndexScan(ci)
IndexScan(n)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
SeqScan(pi)
SeqScan(rt)
SeqScan(kt)
Leading(((((((((pi n) ci) rt) t) kt) mi1) it1) it2))
*/
 SELECT mi1.info, pi.info, COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
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
 AND (it1.id IN ('103')) 
 AND (it2.id IN ('26')) 
 AND (mi1.info ILIKE '%©20%') 
 AND (pi.info ILIKE '%petr%') 
 AND (kt.kind IN ('episode','movie','tv mini series','tv movie','video game','video movie')) 
 AND (rt.role IN ('actor','actress','composer','editor','guest','miscellaneous crew','producer','production designer')) 
 GROUP BY mi1.info, pi.info 
  
;