SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"4-Track Stereo","70 mm 6-Track",DTS,Datasat,"Dolby Digital EX","Dolby SR",Mono,SDDS,Silent}'::text[])));


/*+
HashJoin(mi2 t kt mi1 ci rt n it1 it2)
HashJoin(mi2 t kt mi1 ci rt n it1)
NestLoop(mi2 t kt mi1 ci rt n)
NestLoop(mi2 t kt mi1 ci rt)
NestLoop(mi2 t kt mi1 ci)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
Leading(((((((((mi2 t) kt) mi1) ci) rt) n) it1) it2))
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('5')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('4-Track Stereo','70 mm 6-Track','DTS','Datasat','Dolby Digital EX','Dolby SR','Mono','SDDS','Silent')) 
 AND (mi2.info IN ('Argentina:18','Finland:K-16','France:-12','Hong Kong:I','Hong Kong:IIB','Switzerland:16','UK:PG','West Germany:12')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game')) 
 AND (rt.role in ('cinematographer','director','writer')) 
 AND (n.gender IN ('f')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
  
;