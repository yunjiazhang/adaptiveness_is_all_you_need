SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adult,Comedy,Crime,Drama,Horror,Romance,Thriller}'::text[])));


/*+
NestLoop(it2 it1 mi2 t kt mi1 ci rt n mk k)
NestLoop(it1 mi2 t kt mi1 ci rt n mk k)
HashJoin(mi2 t kt mi1 ci rt n mk k)
NestLoop(mi2 t kt mi1 ci rt n mk)
NestLoop(mi2 t kt mi1 ci rt n)
HashJoin(mi2 t kt mi1 ci rt)
NestLoop(mi2 t kt mi1 ci)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(mk)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi2)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((((mi2 t) kt) mi1) ci) rt) n) mk) k))))
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
   AND (it1.id IN ('3')) 
   AND (it2.id IN ('5')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Adult', 
                     'Comedy', 
                     'Crime', 
                     'Drama', 
                     'Horror', 
                     'Romance', 
                     'Thriller')) 
   AND (mi2.info IN ('Hong Kong:IIB', 
                     'Netherlands:12', 
                     'Netherlands:AL', 
                     'Singapore:PG', 
                     'UK:15', 
                     'UK:PG', 
                     'UK:R18', 
                     'UK:U', 
                     'USA:Not Rated', 
                     'USA:Passed', 
                     'USA:R')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('cinematographer', 
                    'writer')) 
   AND (n.gender IN ('f', 
                     'm')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
;