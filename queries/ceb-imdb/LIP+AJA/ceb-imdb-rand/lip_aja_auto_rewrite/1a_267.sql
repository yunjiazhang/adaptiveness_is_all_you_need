SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Documentary,Drama,Family,Romance}'::text[])));


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
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
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
 AND mi1.info IN ('Documentary','Drama','Family','Romance') 
 AND mi2.info IN ('Argentina:13','Finland:K-12','UK:U','USA:Approved','West Germany:12') 
 AND kt.kind IN ('episode','movie','tv movie') 
 AND rt.role IN ('costume designer') 
 AND n.gender IN ('f','m') 
 AND t.production_year <= 1975 
 AND 1875 < t.production_year 
  
;