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
   AND it2.id = '4' 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND mi1.info IN ('Action', 
                    'Comedy', 
                    'Documentary', 
                    'Drama', 
                    'Romance', 
                    'Short') 
   AND mi2.info IN ('Arabic', 
                    'Cantonese', 
                    'Danish', 
                    'Dutch', 
                    'English', 
                    'Filipino', 
                    'German', 
                    'Japanese', 
                    'Mandarin', 
                    'Spanish') 
   AND kt.kind IN ('episode', 
                   'movie', 
                   'video movie') 
   AND rt.role IN ('costume designer', 
                   'writer') 
   AND n.gender IN ('f', 
                    'm') 
   AND t.production_year <= 2015 
   AND 1925 < t.production_year 
;