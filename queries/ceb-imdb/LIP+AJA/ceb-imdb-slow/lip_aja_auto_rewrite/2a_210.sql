SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Adult,Adventure,Comedy,Crime,Documentary,Family,Musical,Short,Thriller}'::text[])));


/*+
NestLoop(it2 it1 mi1 t kt mi2 ci rt n mk k)
NestLoop(it1 mi1 t kt mi2 ci rt n mk k)
HashJoin(mi1 t kt mi2 ci rt n mk k)
NestLoop(mi1 t kt mi2 ci rt n mk)
NestLoop(mi1 t kt mi2 ci rt n)
HashJoin(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
IndexScan(mk)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((((mi1 t) kt) mi2) ci) rt) n) mk) k))))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
movie_info AS mi2,
info_type AS it2,
cast_info AS ci,
role_type AS rt,
name AS n,
movie_keyword AS mk,
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
   AND (it2.id IN ('3')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Argentina', 
                     'Belgium', 
                     'Canada', 
                     'Czech Republic', 
                     'France', 
                     'Germany', 
                     'Greece', 
                     'India', 
                     'Israel', 
                     'Japan', 
                     'Poland', 
                     'South Korea', 
                     'UK')) 
   AND (mi2.info IN ('Adult', 
                     'Adventure', 
                     'Comedy', 
                     'Crime', 
                     'Documentary', 
                     'Family', 
                     'Musical', 
                     'Short', 
                     'Thriller')) 
   AND (kt.kind IN ('episode', 
                    'movie')) 
   AND (rt.role IN ('actress', 
                    'director')) 
   AND (n.gender IN ('f') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
;