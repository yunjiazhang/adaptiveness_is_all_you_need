SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, n.id)) FROM name AS n 
        WHERE (n.name ~~* '%jos%'::text);


/*+
NestLoop(mi1 it1 t kt ci rt n)
HashJoin(mi1 it1 t kt ci rt)
NestLoop(mi1 it1 t kt ci)
HashJoin(mi1 it1 t kt)
NestLoop(mi1 it1 t)
HashJoin(mi1 it1)
IndexScan(ci)
SeqScan(mi1)
SeqScan(it1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading(((((((mi1 it1) t) kt) ci) rt) n))
*/
 SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year) 
 
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
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.info_type_id = it1.id 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.movie_id = mi1.movie_id 
 AND ci.role_id = rt.id 
 AND (it1.id IN ('3','6','8')) 
 AND (mi1.info IN ('70 mm 6-Track','Bulgaria','Colombia','Croatia','Cuba','DTS-ES','DTS-Stereo','Dominican Republic','Finland','Hong Kong','Ireland','Israel','Norway','Singapore','South Korea','Sweden','Taiwan','Ultra Stereo','Yugoslavia')) 
 AND (n.name ILIKE '%jos%') 
 AND (kt.kind IN ('episode','movie','tv series')) 
 AND (rt.role IN ('cinematographer','composer','editor','writer')) 
 GROUP BY mi1.info, n.name 
  
;