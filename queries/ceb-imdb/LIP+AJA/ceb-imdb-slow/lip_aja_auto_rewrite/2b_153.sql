SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Argentina:13,Canada:AA,France:X,Italy:T,Switzerland:10,USA:E,"West Germany:18"}'::text[]))) AND ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Argentina:13,Canada:AA,France:X,Italy:T,Switzerland:10,USA:E,"West Germany:18"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi1.movie_id)), sum(pg_lip_bloom_add(3, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 8) AND (mi1.info = ANY ('{France,Germany,USA,"West Germany"}'::text[]))) AND ((mi1.info_type_id = 8) AND (mi1.info = ANY ('{France,Germany,USA,"West Germany"}'::text[])));


/*+
NestLoop(k mk t kt mi2 ci mi1 it1 it2 rt n)
HashJoin(k mk t kt mi2 ci mi1 it1 it2 rt)
HashJoin(k mk t kt mi2 ci mi1 it1 it2)
HashJoin(k mk t kt mi2 ci mi1 it1)
HashJoin(k mk t kt mi2 ci mi1)
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
   AND (it1.id IN ('8')) 
   AND (it2.id IN ('5')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('France', 
                     'Germany', 
                     'USA', 
                     'West Germany')) 
   AND (mi2.info IN ('Argentina:13', 
                     'Canada:AA', 
                     'France:X', 
                     'Italy:T', 
                     'Switzerland:10', 
                     'USA:E', 
                     'West Germany:18')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('production designer')) 
   AND (n.gender IS NULL) 
   AND (t.production_year <= 2010) 
   AND (t.production_year >= 1950) 
   AND (k.keyword IN ('blood', 
                      'dancing', 
                      'death', 
                      'father-son-relationship', 
                      'female-nudity', 
                      'fight', 
                      'hardcore', 
                      'independent-film', 
                      'kidnapping', 
                      'love', 
                      'male-frontal-nudity', 
                      'male-nudity', 
                      'mother-daughter-relationship', 
                      'new-york-city', 
                      'one-word-title', 
                      'party', 
                      'singer', 
                      'suicide')) 
;