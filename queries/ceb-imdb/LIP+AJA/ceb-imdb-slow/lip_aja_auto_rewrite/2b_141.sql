SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{Mono,Silent}'::text[])) AND (mi2.info_type_id = 6)) AND ((mi2.info = ANY ('{Mono,Silent}'::text[])) AND (mi2.info_type_id = 6));
SELECT sum(pg_lip_bloom_add(2, mi1.movie_id)), sum(pg_lip_bloom_add(3, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",MET:,"MET:100 m","MET:15.2 m","MET:1500 m","MET:23 m","MET:30 m","MET:300 m",PCS:Panavision,PCS:Techniscope,"PFM:16 mm","PFM:68 mm","RAT:1.36 : 1","RAT:1.37 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",MET:,"MET:100 m","MET:15.2 m","MET:1500 m","MET:23 m","MET:30 m","MET:300 m",PCS:Panavision,PCS:Techniscope,"PFM:16 mm","PFM:68 mm","RAT:1.36 : 1","RAT:1.37 : 1"}'::text[])));


/*+
NestLoop(k mk t kt mi2 ci mi1 it1 it2 rt n)
NestLoop(k mk t kt mi2 ci mi1 it1 it2 rt)
HashJoin(k mk t kt mi2 ci mi1 it1 it2)
HashJoin(k mk t kt mi2 ci mi1 it1)
NestLoop(k mk t kt mi2 ci mi1)
NestLoop(k mk t kt mi2 ci)
NestLoop(k mk t kt mi2)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(k)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((((k mk) t) kt) mi2) ci) mi1) it1) it2) rt) n))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(1, t.id)  AND pg_lip_bloom_probe(2, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
movie_info AS mi2,
info_type AS it2,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(3, ci.movie_id) 
) AS ci,
role_type AS rt,
name AS n,
(
    SELECT * FROM movie_keyword AS mk
    WHERE 
pg_lip_bloom_probe(0, mk.movie_id) 
) AS mk,
keyword AS k
WHERE 
 t.id = ci.movie_id 
   AND t.id = mi1.movie_id 
   AND t.id = mi2.movie_id 
   AND t.id = mk.movie_id 
   AND k.id = mk.keyword_id 
   AND mi1.movie_id = mi2.movie_id 
   AND mi1.info_type_id = it1.id 
   AND mi2.info_type_id = it2.id 
   AND (it1.id IN ('7')) 
   AND (it2.id IN ('6')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA', 
                     'MET:', 
                     'MET:100 m', 
                     'MET:15.2 m', 
                     'MET:1500 m', 
                     'MET:23 m', 
                     'MET:30 m', 
                     'MET:300 m', 
                     'PCS:Panavision', 
                     'PCS:Techniscope', 
                     'PFM:16 mm', 
                     'PFM:68 mm', 
                     'RAT:1.36 : 1', 
                     'RAT:1.37 : 1')) 
   AND (mi2.info IN ('Mono', 
                     'Silent')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('director', 
                    'producer')) 
   AND (n.gender IN ('f') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1875) 
   AND (k.keyword IN ('based-on-play', 
                      'doctor', 
                      'hardcore', 
                      'jealousy', 
                      'new-york-city', 
                      'one-word-title')) 
;