SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{"Dolby Digital",Mono}'::text[])) AND (mi2.info_type_id = 6)) AND ((mi2.info = ANY ('{"Dolby Digital",Mono}'::text[])) AND (mi2.info_type_id = 6));
SELECT sum(pg_lip_bloom_add(2, mi1.movie_id)), sum(pg_lip_bloom_add(3, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:Atp,Australia:G,Germany:16,Iceland:12,Norway:16,Portugal:M/12,Singapore:NC-16,Sweden:Btl,UK:15,USA:G,USA:TV-14}'::text[]))) AND ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:Atp,Australia:G,Germany:16,Iceland:12,Norway:16,Portugal:M/12,Singapore:NC-16,Sweden:Btl,UK:15,USA:G,USA:TV-14}'::text[])));


/*+
NestLoop(k mk t kt mi2 mi1 it1 it2 ci rt n)
HashJoin(k mk t kt mi2 mi1 it1 it2 ci rt)
NestLoop(k mk t kt mi2 mi1 it1 it2 ci)
HashJoin(k mk t kt mi2 mi1 it1 it2)
HashJoin(k mk t kt mi2 mi1 it1)
NestLoop(k mk t kt mi2 mi1)
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
Leading(((((((((((k mk) t) kt) mi2) mi1) it1) it2) ci) rt) n))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(1, t.id)  AND pg_lip_bloom_probe(3, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
movie_info AS mi2,
info_type AS it2,
cast_info AS ci,
role_type AS rt,
name AS n,
(
    SELECT * FROM movie_keyword AS mk
    WHERE 
pg_lip_bloom_probe(0, mk.movie_id)  AND pg_lip_bloom_probe(2, mk.movie_id) 
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
   AND (it2.id IN ('6')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Argentina:Atp', 
                     'Australia:G', 
                     'Germany:16', 
                     'Iceland:12', 
                     'Norway:16', 
                     'Portugal:M/12', 
                     'Singapore:NC-16', 
                     'Sweden:Btl', 
                     'UK:15', 
                     'USA:G', 
                     'USA:TV-14')) 
   AND (mi2.info IN ('Dolby Digital', 
                     'Mono')) 
   AND (kt.kind IN ('movie', 
                    'video movie')) 
   AND (rt.role IN ('producer')) 
   AND (n.gender IN ('m')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
   AND (k.keyword IN ('anal-sex', 
                      'based-on-novel', 
                      'dancing', 
                      'family-relationships', 
                      'father-daughter-relationship', 
                      'female-nudity', 
                      'fight', 
                      'gay', 
                      'homosexual', 
                      'hospital', 
                      'husband-wife-relationship', 
                      'interview', 
                      'kidnapping', 
                      'one-word-title', 
                      'police', 
                      'sex', 
                      'singing', 
                      'song', 
                      'violence')) 
;