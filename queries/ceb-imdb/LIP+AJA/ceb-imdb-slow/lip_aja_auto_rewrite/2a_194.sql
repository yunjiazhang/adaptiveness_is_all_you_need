SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"Dolby Digital",Mono,SDDS,Stereo}'::text[])));


/*+
HashJoin(mi2 t kt mi1 it1 it2 ci rt n mk k)
NestLoop(mi2 t kt mi1 it1 it2 ci rt n mk)
NestLoop(mi2 t kt mi1 it1 it2 ci rt n)
HashJoin(mi2 t kt mi1 it1 it2 ci rt)
NestLoop(mi2 t kt mi1 it1 it2 ci)
HashJoin(mi2 t kt mi1 it1 it2)
HashJoin(mi2 t kt mi1 it1)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(mk)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading(((((((((((mi2 t) kt) mi1) it1) it2) ci) rt) n) mk) k))
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
   AND (it1.id IN ('6')) 
   AND (it2.id IN ('18')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Dolby Digital', 
                     'Mono', 
                     'SDDS', 
                     'Stereo')) 
   AND (mi2.info IN ('Buenos Aires, Federal District, Argentina', 
                     'CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA', 
                     'London, England, UK', 
                     'Los Angeles, California, USA', 
                     'New York City, New York, USA', 
                     'Paris, France', 
                     'Toronto, Ontario, Canada', 
                     'Universal Studios - 100 Universal City Plaza, Universal City, California, USA')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('actress', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('f') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1975) 
;