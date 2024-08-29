SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 18) AND (mi2.info = ANY ('{"Jacksonville, Florida, USA","Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA","Santa Catalina Island, Channel Islands, California, USA","Stage 30, Universal Studios - 100 Universal City Plaza, Universal City, California, USA","Stage 4, Stage 1, Stage 1, NBC Studios - 3000 W. Alameda Avenue, Burbank, California, USA"}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA","LAB:Film Center, Mumbai, India","LAB:Rank Film Laboratories, Denham, UK","OFM:35 mm",OFM:Live,OFM:Video,PCS:Panavision,"RAT:2.20 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA","LAB:Film Center, Mumbai, India","LAB:Rank Film Laboratories, Denham, UK","OFM:35 mm",OFM:Live,OFM:Video,PCS:Panavision,"RAT:2.20 : 1"}'::text[])));


/*+
NestLoop(t kt mi2 ci rt mi1 it1 it2 n)
NestLoop(t kt mi2 ci rt mi1 it1 it2)
NestLoop(t kt mi2 ci rt mi1 it1)
NestLoop(t kt mi2 ci rt mi1)
NestLoop(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
SeqScan(t)
Leading(((((((((t kt) mi2) ci) rt) mi1) it1) it2) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id)  AND pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(2, ci.movie_id) 
) AS ci,
role_type as rt,
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('7')) 
 AND (it2.id in ('18')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','LAB:Film Center, Mumbai, India','LAB:Rank Film Laboratories, Denham, UK','OFM:35 mm','OFM:Live','OFM:Video','PCS:Panavision','RAT:2.20 : 1')) 
 AND (mi2.info IN ('Jacksonville, Florida, USA','Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA','Santa Catalina Island, Channel Islands, California, USA','Stage 30, Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Stage 4, Stage 1, Stage 1, NBC Studios - 3000 W. Alameda Avenue, Burbank, California, USA')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game')) 
 AND (rt.role in ('actor','production designer','writer')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (t.title in ('(#1.30)','(#1.49)','(#1.57)','(#1.59)','(#2.21)','(#2.4)','(#5.18)','(#5.26)','(#8.5)','An Eye for an Eye','Another World','Bad Boy','Candida','Casanova Brown','Counterfeit','Die Fledermaus','Die Ratten','Ever Since Eve','Hobsons Choice','Holiday','Jeanne Eagels','La cieca di Sorrento','Nob Hill','Sahara','Test Pilot','The Payoff','The Rainmaker','The Winning Ticket','Too Many Cooks')) 
  
;