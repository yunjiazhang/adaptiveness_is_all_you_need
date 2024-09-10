SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Action,Adventure,Crime,Documentary,Drama,Romance,War}'::text[])));


/*+
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n k)
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n)
HashJoin(mi1 t kt mi2 it1 it2 mk ci rt)
NestLoop(mi1 t kt mi2 it1 it2 mk ci)
NestLoop(mi1 t kt mi2 it1 it2 mk)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
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
   AND (it1.id IN ('5')) 
   AND (it2.id IN ('3')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Argentina:13', 
                     'Australia:G', 
                     'Australia:M', 
                     'Australia:PG', 
                     'Belgium:KT', 
                     'Finland:K-12', 
                     'Finland:K-16', 
                     'Sweden:15', 
                     'UK:A', 
                     'USA:Approved', 
                     'USA:Not Rated', 
                     'West Germany:16', 
                     'West Germany:18')) 
   AND (mi2.info IN ('Action', 
                     'Adventure', 
                     'Crime', 
                     'Documentary', 
                     'Drama', 
                     'Romance', 
                     'War')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('production designer')) 
   AND (n.gender IN ('f')) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1925) 
;