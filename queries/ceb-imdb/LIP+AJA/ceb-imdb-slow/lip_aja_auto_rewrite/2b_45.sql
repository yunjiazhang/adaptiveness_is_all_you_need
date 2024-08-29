SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:13,Brazil:12,Germany:6,Netherlands:AL,"New Zealand:R18",Norway:18,Spain:13,Spain:T,Sweden:Btl,"West Germany:12"}'::text[]))) AND ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:13,Brazil:12,Germany:6,Netherlands:AL,"New Zealand:R18",Norway:18,Spain:13,Spain:T,Sweden:Btl,"West Germany:12"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Argentina,Germany,Netherlands,Spain,UK,USA}'::text[]))) AND ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Argentina,Germany,Netherlands,Spain,UK,USA}'::text[])));


/*+
NestLoop(k mk t kt mi1 it1 ci mi2 it2 rt n)
HashJoin(k mk t kt mi1 it1 ci mi2 it2 rt)
HashJoin(k mk t kt mi1 it1 ci mi2 it2)
HashJoin(k mk t kt mi1 it1 ci mi2)
NestLoop(k mk t kt mi1 it1 ci)
HashJoin(k mk t kt mi1 it1)
NestLoop(k mk t kt mi1)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mi1)
IndexScan(mi2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(k)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((((k mk) t) kt) mi1) it1) ci) mi2) it2) rt) n))
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
   AND (it1.id IN ('5')) 
   AND (it2.id IN ('8')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Argentina:13', 
                     'Brazil:12', 
                     'Germany:6', 
                     'Netherlands:AL', 
                     'New Zealand:R18', 
                     'Norway:18', 
                     'Spain:13', 
                     'Spain:T', 
                     'Sweden:Btl', 
                     'West Germany:12')) 
   AND (mi2.info IN ('Argentina', 
                     'Germany', 
                     'Netherlands', 
                     'Spain', 
                     'UK', 
                     'USA')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('actress', 
                    'costume designer')) 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1975) 
   AND (k.keyword IN ('blood', 
                      'death', 
                      'father-daughter-relationship', 
                      'female-frontal-nudity', 
                      'female-nudity', 
                      'homosexual', 
                      'hospital', 
                      'lesbian', 
                      'marriage', 
                      'mother-daughter-relationship', 
                      'non-fiction', 
                      'nudity', 
                      'oral-sex', 
                      'singer', 
                      'tv-mini-series')) 
;