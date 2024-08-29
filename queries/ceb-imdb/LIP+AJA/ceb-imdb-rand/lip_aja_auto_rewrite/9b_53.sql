SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Comedy,Documentary,Drama,Horror,Short,Thriller}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Comedy,Documentary,Drama,Horror,Short,Thriller}'::text[])));


/*+
HashJoin(n pi ci rt t kt mi1 it1 it2)
HashJoin(n pi ci rt t kt mi1 it1)
NestLoop(n pi ci rt t kt mi1)
NestLoop(n pi ci rt t kt)
NestLoop(n pi ci rt t)
HashJoin(n pi ci rt)
NestLoop(n pi ci)
NestLoop(n pi)
IndexScan(mi1)
IndexScan(pi)
IndexScan(ci)
IndexScan(kt)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
SeqScan(rt)
SeqScan(n)
Leading(((((((((n pi) ci) rt) t) kt) mi1) it1) it2))
*/
 SELECT mi1.info, n.name, COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.movie_id) 
) AS ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.info_type_id = it1.id 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.movie_id = mi1.movie_id 
 AND ci.role_id = rt.id 
 AND n.id = pi.person_id 
 AND pi.info_type_id = it2.id 
 AND (it1.id IN ('3')) 
 AND (it2.id IN ('26')) 
 AND (mi1.info IN ('Action','Comedy','Documentary','Drama','Horror','Short','Thriller')) 
 AND (n.name ILIKE '%cree%') 
 AND (kt.kind IN ('episode','movie','tv movie')) 
 AND (rt.role IN ('actor','actress','costume designer')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 GROUP BY mi1.info, n.name 
  
;