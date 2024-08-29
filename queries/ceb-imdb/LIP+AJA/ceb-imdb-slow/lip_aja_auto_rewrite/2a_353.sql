SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 4) AND (mi2.info = 'English'::text));


/*+
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n k)
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n)
HashJoin(mi1 t kt mi2 it1 it2 mk ci rt)
NestLoop(mi1 t kt mi2 it1 it2 mk ci)
NestLoop(mi1 t kt mi2 it1 it2 mk)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
NestLoop(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(kt)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
Leading(((((((((((mi1 t) kt) mi2) it1) it2) mk) ci) rt) n) k))
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
   AND (it1.id IN ('18')) 
   AND (it2.id IN ('4')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA', 
                     'General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA', 
                     'Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA', 
                     'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA', 
                     'Revue Studios, Hollywood, Los Angeles, California, USA', 
                     'Universal Studios - 100 Universal City Plaza, Universal City, California, USA', 
                     'Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
   AND (mi2.info IN ('English')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('director', 
                    'writer')) 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1875) 
;