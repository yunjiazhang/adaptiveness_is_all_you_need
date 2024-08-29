SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 4) AND (mi1.info = 'Japanese'::text)) AND ((mi1.info_type_id = 4) AND (mi1.info = 'Japanese'::text));


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
 AND (it1.id IN ('4')) 
 AND (mi1.info IN ('Japanese')) 
 AND (n.name ILIKE '%such%') 
 AND (kt.kind IN ('tv series')) 
 AND (rt.role IN ('actor','actress','cinematographer','composer')) 
 GROUP BY mi1.info, n.name 
  
;