SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Adventure,Drama,Family,Mystery,Romance,Thriller}'::text[])));


/*+
NestLoop(mi2 t kt mi1 ci rt it1 it2 n)
HashJoin(mi2 t kt mi1 ci rt it1 it2)
HashJoin(mi2 t kt mi1 ci rt it1)
NestLoop(mi2 t kt mi1 ci rt)
NestLoop(mi2 t kt mi1 ci)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((mi2 t) kt) mi1) ci) rt) it1) it2) n))
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
   AND it1.id = '3' 
   AND it2.id = '5' 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND mi1.info IN ('Action', 
                    'Adventure', 
                    'Drama', 
                    'Family', 
                    'Mystery', 
                    'Romance', 
                    'Thriller') 
   AND mi2.info IN ('Argentina:16', 
                    'Brazil:14', 
                    'Canada:13+', 
                    'Finland:K-16', 
                    'France:-12', 
                    'Hong Kong:IIB', 
                    'Hong Kong:III', 
                    'Ireland:15A', 
                    'South Korea:All', 
                    'Spain:13', 
                    'UK:U') 
   AND kt.kind IN ('movie', 
                   'video movie') 
   AND rt.role IN ('actress') 
   AND n.gender IN ('f') 
   AND t.production_year <= 2015 
   AND 1925 < t.production_year 
;