SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{DTS,"Dolby Digital",Dolby,Mono,Stereo}'::text[]))) AND ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{DTS,"Dolby Digital",Dolby,Mono,Stereo}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Canada:18A,Canada:G,Iceland:16,Netherlands:AL,Sweden:11,Switzerland:12,USA:PG}'::text[]))) AND ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Canada:18A,Canada:G,Iceland:16,Netherlands:AL,Sweden:11,Switzerland:12,USA:PG}'::text[])));


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
   AND (it2.id IN ('5')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('DTS', 
                     'Dolby Digital', 
                     'Dolby', 
                     'Mono', 
                     'Stereo')) 
   AND (mi2.info IN ('Canada:18A', 
                     'Canada:G', 
                     'Iceland:16', 
                     'Netherlands:AL', 
                     'Sweden:11', 
                     'Switzerland:12', 
                     'USA:PG')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('costume designer', 
                    'writer')) 
   AND (n.gender IN ('f')) 
   AND (t.production_year <= 2010) 
   AND (t.production_year >= 1950) 
   AND (k.keyword IN ('based-on-novel', 
                      'lesbian-sex', 
                      'male-nudity', 
                      'nudity', 
                      'one-word-title', 
                      'party', 
                      'sex', 
                      'suicide', 
                      'surrealism', 
                      'tv-mini-series')) 
;