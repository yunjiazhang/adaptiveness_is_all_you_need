SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Animation,Comedy,Crime,Documentary,Musical,Romance}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"OFM:35 mm",PCS:Spherical,"PFM:35 mm","RAT:1.37 : 1"}'::text[])));


/*+
HashJoin(t kt mi1 mi2 ci rt n it1 it2)
HashJoin(t kt mi1 mi2 ci rt n it1)
NestLoop(t kt mi1 mi2 ci rt n)
HashJoin(t kt mi1 mi2 ci rt)
NestLoop(t kt mi1 mi2 ci)
NestLoop(t kt mi1 mi2)
NestLoop(t kt mi1)
HashJoin(t kt)
IndexScan(mi1)
IndexScan(mi2)
IndexScan(ci)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading(((((((((t kt) mi1) mi2) ci) rt) n) it1) it2))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id)  AND pg_lip_bloom_probe(1, t.id) 
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
 AND it2.id = '7' 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info IN ('Animation','Comedy','Crime','Documentary','Musical','Romance') 
 AND mi2.info IN ('OFM:35 mm','PCS:Spherical','PFM:35 mm','RAT:1.37 : 1') 
 AND kt.kind IN ('tv movie','tv series') 
 AND rt.role IN ('actress') 
 AND n.gender IN ('f') 
 AND t.production_year <= 1949 
 AND 1928 < t.production_year 
  
;