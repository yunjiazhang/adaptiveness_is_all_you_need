SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Australia:R,Brazil:14,Canada:14A,Italy:T,Malaysia:U,Mexico:B,Netherlands:12,Peru:PT,Spain:T,Switzerland:10,Switzerland:14,UK:12A,USA:G,USA:Passed,USA:R,USA:TV-PG}'::text[]))) AND ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Australia:R,Brazil:14,Canada:14A,Italy:T,Malaysia:U,Mexico:B,Netherlands:12,Peru:PT,Spain:T,Switzerland:10,Switzerland:14,UK:12A,USA:G,USA:Passed,USA:R,USA:TV-PG}'::text[])));


/*+
HashJoin(n ci rt t kt mi1 it1)
NestLoop(n ci rt t kt mi1)
HashJoin(n ci rt t kt)
NestLoop(n ci rt t)
HashJoin(n ci rt)
NestLoop(n ci)
IndexScan(mi1)
IndexScan(ci)
IndexScan(t)
SeqScan(it1)
SeqScan(rt)
SeqScan(kt)
SeqScan(n)
Leading(((((((n ci) rt) t) kt) mi1) it1))
*/
 SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
) AS ci,
role_type as rt,
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.info_type_id = it1.id 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.movie_id = mi1.movie_id 
 AND ci.role_id = rt.id 
 AND (it1.id IN ('5')) 
 AND (mi1.info IN ('Australia:R','Brazil:14','Canada:14A','Italy:T','Malaysia:U','Mexico:B','Netherlands:12','Peru:PT','Spain:T','Switzerland:10','Switzerland:14','UK:12A','USA:G','USA:Passed','USA:R','USA:TV-PG')) 
 AND (n.name ILIKE '%dou%') 
 AND (kt.kind IN ('episode','movie','tv movie')) 
 AND (rt.role IN ('editor','miscellaneous crew','producer')) 
 GROUP BY mi1.info, n.name 
  
;