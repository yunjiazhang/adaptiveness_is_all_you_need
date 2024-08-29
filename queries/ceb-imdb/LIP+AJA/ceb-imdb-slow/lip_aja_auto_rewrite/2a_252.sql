SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi1 mi2 t kt ci rt n mk k)
NestLoop(it1 mi1 mi2 t kt ci rt n mk k)
HashJoin(mi1 mi2 t kt ci rt n mk k)
NestLoop(mi1 mi2 t kt ci rt n mk)
NestLoop(mi1 mi2 t kt ci rt n)
HashJoin(mi1 mi2 t kt ci rt)
NestLoop(mi1 mi2 t kt ci)
HashJoin(mi1 mi2 t kt)
NestLoop(mi1 mi2 t)
HashJoin(mi1 mi2)
IndexScan(ci)
IndexScan(mk)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
SeqScan(mi2)
IndexScan(t)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((((mi1 mi2) t) kt) ci) rt) n) mk) k))))
*/
 SELECT COUNT(*) 
 
FROM 
title AS t,
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
   AND (it2.id IN ('2')) 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (mi1.info IN ('Action', 
                     'Adult', 
                     'Adventure', 
                     'Comedy', 
                     'Documentary', 
                     'Family', 
                     'Fantasy', 
                     'History', 
                     'Sci-Fi', 
                     'Thriller')) 
   AND (mi2.info IN ('Color')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'video movie')) 
   AND (rt.role IN ('miscellaneous crew', 
                    'producer')) 
   AND (n.gender IN ('f', 
                     'm')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1990) 
;