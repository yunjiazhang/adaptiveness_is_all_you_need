SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{DTS,"Dolby Digital","Dolby SR",Dolby,Mono,Stereo}'::text[]))) AND ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{DTS,"Dolby Digital","Dolby SR",Dolby,Mono,Stereo}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Action,Biography,Comedy,Crime,Documentary,Fantasy,History,Romance}'::text[]))) AND ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Action,Biography,Comedy,Crime,Documentary,Fantasy,History,Romance}'::text[])));


/*+
NestLoop(k mk t kt mi1 it1 mi2 it2 ci rt n)
HashJoin(k mk t kt mi1 it1 mi2 it2 ci rt)
NestLoop(k mk t kt mi1 it1 mi2 it2 ci)
HashJoin(k mk t kt mi1 it1 mi2 it2)
NestLoop(k mk t kt mi1 it1 mi2)
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
Leading(((((((((((k mk) t) kt) mi1) it1) mi2) it2) ci) rt) n))
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
   AND (it1.id IN ('6')) 
   AND (it2.id IN ('3')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('DTS', 
                     'Dolby Digital', 
                     'Dolby SR', 
                     'Dolby', 
                     'Mono', 
                     'Stereo')) 
   AND (mi2.info IN ('Action', 
                     'Biography', 
                     'Comedy', 
                     'Crime', 
                     'Documentary', 
                     'Fantasy', 
                     'History', 
                     'Romance')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('producer')) 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
   AND (k.keyword IN ('bare-breasts', 
                      'based-on-novel', 
                      'blood', 
                      'character-name-in-title', 
                      'death', 
                      'doctor', 
                      'female-nudity', 
                      'homosexual', 
                      'husband-wife-relationship', 
                      'interview', 
                      'jealousy', 
                      'love', 
                      'male-frontal-nudity', 
                      'marriage', 
                      'mother-daughter-relationship', 
                      'mother-son-relationship', 
                      'murder', 
                      'nudity', 
                      'revenge', 
                      'singer', 
                      'suicide', 
                      'tv-mini-series')) 
;