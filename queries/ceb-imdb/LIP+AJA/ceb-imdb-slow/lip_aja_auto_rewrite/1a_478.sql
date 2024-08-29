SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 4) AND (mi2.info = ANY ('{Catalan,Czech,Danish,English,French,German,Hebrew,Hungarian,Norwegian,Polish,Turkish}'::text[])));


/*+
NestLoop(it2 it1 mi1 t kt mi2 ci rt n)
NestLoop(it1 mi1 t kt mi2 ci rt n)
NestLoop(mi1 t kt mi2 ci rt n)
HashJoin(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi1 t) kt) mi2) ci) rt) n))))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type AS kt,
movie_info AS mi1,
info_type AS it1,
movie_info AS mi2,
info_type AS it2,
cast_info AS ci,
role_type AS rt,
name AS n
WHERE 
 t.id = ci.movie_id 
   AND t.id = mi1.movie_id 
   AND t.id = mi2.movie_id 
   AND mi1.movie_id = mi2.movie_id 
   AND mi1.info_type_id = it1.id 
   AND mi2.info_type_id = it2.id 
   AND it1.id = '8' 
   AND it2.id = '4' 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND mi1.info IN ('Australia', 
                    'Czech Republic', 
                    'Czechoslovakia', 
                    'Denmark', 
                    'France', 
                    'Hungary', 
                    'Israel', 
                    'Norway', 
                    'Poland', 
                    'Spain', 
                    'Turkey', 
                    'USA', 
                    'West Germany') 
   AND mi2.info IN ('Catalan', 
                    'Czech', 
                    'Danish', 
                    'English', 
                    'French', 
                    'German', 
                    'Hebrew', 
                    'Hungarian', 
                    'Norwegian', 
                    'Polish', 
                    'Turkish') 
   AND kt.kind IN ('episode', 
                   'movie') 
   AND rt.role IN ('writer') 
   AND n.gender IN ('m') 
   AND t.production_year <= 2015 
   AND 1925 < t.production_year 
;