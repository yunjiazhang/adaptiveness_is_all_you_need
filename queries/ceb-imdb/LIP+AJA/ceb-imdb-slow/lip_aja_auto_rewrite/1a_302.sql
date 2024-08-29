SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(it2 it1 mi2 mi1 t kt ci rt n)
NestLoop(it1 mi2 mi1 t kt ci rt n)
NestLoop(mi2 mi1 t kt ci rt n)
HashJoin(mi2 mi1 t kt ci rt)
NestLoop(mi2 mi1 t kt ci)
HashJoin(mi2 mi1 t kt)
NestLoop(mi2 mi1 t)
HashJoin(mi2 mi1)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi2)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi2 mi1) t) kt) ci) rt) n))))
*/
 SELECT COUNT(*) 
 
FROM 
title AS t,
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
   AND it2.id = '7' 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND mi1.info IN ('Comedy', 
                    'Documentary', 
                    'Drama', 
                    'Fantasy', 
                    'Romance', 
                    'Short', 
                    'Thriller') 
   AND mi2.info IN ('OFM:16 mm', 
                    'OFM:35 mm', 
                    'PCS:Spherical', 
                    'PFM:35 mm', 
                    'RAT:1.33 : 1', 
                    'RAT:1.78 : 1 / (high definition)', 
                    'RAT:1.78 : 1', 
                    'RAT:1.85 : 1', 
                    'RAT:16:9 HD') 
   AND kt.kind IN ('episode', 
                   'movie', 
                   'video movie') 
   AND rt.role IN ('miscellaneous crew', 
                   'writer') 
   AND n.gender IN ('m') 
   AND t.production_year <= 2015 
   AND 1990 < t.production_year 
;