SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"MET:300 m","OFM:16 mm","OFM:35 mm",PCS:Spherical,"PFM:16 mm","PFM:35 mm","RAT:1.37 : 1","RAT:1.66 : 1","RAT:2.35 : 1"}'::text[])));


/*+
NestLoop(it2 it1 mi1 t kt mi2 ci rt n)
NestLoop(it1 mi1 t kt mi2 ci rt n)
NestLoop(mi1 t kt mi2 ci rt n)
HashJoin(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((it2 (it1 (((((mi1 (t kt)) mi2) ci) rt) n))))
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
 AND it2.id = '7' 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info IN ('Action','Comedy','Documentary','History','Music','Short','Sport','War') 
 AND mi2.info IN ('MET:300 m','OFM:16 mm','OFM:35 mm','PCS:Spherical','PFM:16 mm','PFM:35 mm','RAT:1.37 : 1','RAT:1.66 : 1','RAT:2.35 : 1') 
 AND kt.kind IN ('tv movie') 
 AND rt.role IN ('actor','writer') 
 AND n.gender IN ('m') 
 AND t.production_year <= 1975 
 AND 1925 < t.production_year 
  
;