SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{English,Spanish}'::text[])) AND (mi1.info_type_id = 4));


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
   AND (it1.id IN ('4')) 
   AND (it2.id IN ('18')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('English', 
                     'Spanish')) 
   AND (mi2.info IN ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA', 
                     'Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA', 
                     'Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA', 
                     'Mexico', 
                     'New York City, New York, USA', 
                     'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA', 
                     'Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA', 
                     'Revue Studios, Hollywood, Los Angeles, California, USA', 
                     'Universal Studios - 100 Universal City Plaza, Universal City, California, USA', 
                     'Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('actor')) 
   AND (n.gender IN ('m')) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1925) 
;