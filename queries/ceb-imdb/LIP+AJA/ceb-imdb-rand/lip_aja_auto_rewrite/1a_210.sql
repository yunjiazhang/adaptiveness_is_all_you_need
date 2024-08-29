SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 6) AND (mi2.info = ANY ('{"4-Track Stereo","70 mm 6-Track","Dolby Digital",Mono,Silent,Stereo}'::text[])));


/*+
NestLoop(mi1 t kt mi2 it1 it2 ci rt n)
NestLoop(mi1 t kt mi2 it1 it2 ci rt)
NestLoop(mi1 t kt mi2 it1 it2 ci)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((mi1 t) kt) mi2) it1) it2) ci) rt) n))
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
 AND (it1.id in ('16')) 
 AND (it2.id in ('6')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('France:1908','France:1909','Italy:1913','USA:1954','USA:January 1903')) 
 AND (mi2.info IN ('4-Track Stereo','70 mm 6-Track','Dolby Digital','Mono','Silent','Stereo')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('actress','composer','costume designer','editor')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
  
;