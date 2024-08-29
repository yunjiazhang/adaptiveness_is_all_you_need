SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"4-Track Stereo","70 mm 6-Track","Dolby Digital","Dolby SR",Dolby,Mono,"Ultra Stereo"}'::text[])));


/*+
NestLoop(mi2 t kt mi1 it1 it2 ci rt n)
NestLoop(mi2 t kt mi1 it1 it2 ci rt)
NestLoop(mi2 t kt mi1 it1 it2 ci)
HashJoin(mi2 t kt mi1 it1 it2)
HashJoin(mi2 t kt mi1 it1)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((mi2 t) kt) mi1) it1) it2) ci) rt) n))
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
 AND (it2.id in ('18')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('4-Track Stereo','70 mm 6-Track','Dolby Digital','Dolby SR','Dolby','Mono','Ultra Stereo')) 
 AND (mi2.info IN ('CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA','Mexico','Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA','Samuel Goldwyn Studios - 7200 Santa Monica Boulevard, West Hollywood, California, USA','Stage 28, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA','Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Studio 33, CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
 AND (kt.kind in ('episode','movie','video game','video movie')) 
 AND (rt.role in ('director','guest','miscellaneous crew','production designer','writer')) 
 AND (n.gender IN ('f','m')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
  
;