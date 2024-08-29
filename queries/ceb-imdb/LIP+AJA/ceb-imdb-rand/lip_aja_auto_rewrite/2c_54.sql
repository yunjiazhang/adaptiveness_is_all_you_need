SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",LAB:DeLuxe,LAB:Technicolor,"MET:100 m","MET:15.2 m","MET:150 m","MET:900 m","OFM:16 mm","OFM:35 mm",PCS:Spherical,"PFM:68 mm","RAT:1.37 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2)) AND ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2));


/*+
NestLoop(t kt mi2 mi1 it1 it2 ci rt n)
NestLoop(t kt mi2 mi1 it1 it2 ci rt)
NestLoop(t kt mi2 mi1 it1 it2 ci)
HashJoin(t kt mi2 mi1 it1 it2)
HashJoin(t kt mi2 mi1 it1)
NestLoop(t kt mi2 mi1)
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
Leading(((((((((t kt) mi2) mi1) it1) it2) ci) rt) n))
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
(
    SELECT * FROM movie_info as mi2
    WHERE 
pg_lip_bloom_probe(2, mi2.movie_id) 
) AS mi2,
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
 AND (it1.id in ('2')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Black AND White','Color')) 
 AND (mi2.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','LAB:DeLuxe','LAB:Technicolor','MET:100 m','MET:15.2 m','MET:150 m','MET:900 m','OFM:16 mm','OFM:35 mm','PCS:Spherical','PFM:68 mm','RAT:1.37 : 1')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video movie')) 
 AND (rt.role in ('actress','director','miscellaneous crew')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (t.title in ('(#1.108)','(#2.21)','(#3.32)','Blue Skies','Honeymoon','Joan of Arc','My Favorite Spy','Never Say Die','Night AND Day','Perfect Strangers','Reign of Terror','Resurrection','San Francisco','Stella','The Clock','The Engagement','The Fall Guy','The Hound of the Baskervilles','The Journey','The Kid','Welcome Stranger','Yôsei Gorasu')) 
  
;