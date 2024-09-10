SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{MET:,"MET:100 m","MET:23 m","MET:600 m","OFM:35 mm","OFM:68 mm",PCS:Spherical}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adventure,Crime,Documentary,Fantasy,Short,Sport,Western}'::text[])));


/*+
NestLoop(t kt mi2 mi1 it1 it2 ci rt n)
HashJoin(t kt mi2 mi1 it1 it2 ci rt)
NestLoop(t kt mi2 mi1 it1 it2 ci)
HashJoin(t kt mi2 mi1 it1 it2)
HashJoin(t kt mi2 mi1 it1)
NestLoop(t kt mi2 mi1)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading(((((((((t kt) mi2) mi1) it1) it2) ci) rt) n))
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
 AND mi1.info IN ('Adventure','Crime','Documentary','Fantasy','Short','Sport','Western') 
 AND mi2.info IN ('MET:','MET:100 m','MET:23 m','MET:600 m','OFM:35 mm','OFM:68 mm','PCS:Spherical') 
 AND kt.kind IN ('movie') 
 AND rt.role IN ('composer','producer') 
 AND n.gender IN ('m') 
 AND t.production_year <= 1925 
 AND 1875 < t.production_year 
  
;