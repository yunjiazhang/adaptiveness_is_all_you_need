SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Australia:G,Australia:M,Finland:K-16,UK:15,UK:U,"West Germany:16","West Germany:6"}'::text[])));


/*+
NestLoop(mi2 t kt mi1 it1 it2 mk ci rt n k)
NestLoop(mi2 t kt mi1 it1 it2 mk ci rt n)
HashJoin(mi2 t kt mi1 it1 it2 mk ci rt)
NestLoop(mi2 t kt mi1 it1 it2 mk ci)
NestLoop(mi2 t kt mi1 it1 it2 mk)
HashJoin(mi2 t kt mi1 it1 it2)
HashJoin(mi2 t kt mi1 it1)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
Leading(((((((((((mi2 t) kt) mi1) it1) it2) mk) ci) rt) n) k))
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
   AND (it1.id IN ('5')) 
   AND (it2.id IN ('6')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Australia:G', 
                     'Australia:M', 
                     'Finland:K-16', 
                     'UK:15', 
                     'UK:U', 
                     'West Germany:16', 
                     'West Germany:6')) 
   AND (mi2.info IN ('Mono')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('composer')) 
   AND (n.gender IS NULL) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
;