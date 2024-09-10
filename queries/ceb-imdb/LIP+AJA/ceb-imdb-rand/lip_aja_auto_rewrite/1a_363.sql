SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi2.info_type_id = 2));


/*+
NestLoop(mi1 t mi2 kt it1 it2 ci rt n)
NestLoop(mi1 t mi2 kt it1 it2 ci rt)
NestLoop(mi1 t mi2 kt it1 it2 ci)
HashJoin(mi1 t mi2 kt it1 it2)
HashJoin(mi1 t mi2 kt it1)
NestLoop(mi1 t mi2 kt)
NestLoop(mi1 t mi2)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
Leading(((((((((mi1 t) mi2) kt) it1) it2) ci) rt) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('18')) 
 AND (it2.id in ('2')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA','Madrid, Spain','Philippines','Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA')) 
 AND (mi2.info IN ('Black AND White','Color')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('costume designer','director','editor','miscellaneous crew')) 
 AND (n.gender IN ('f') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;