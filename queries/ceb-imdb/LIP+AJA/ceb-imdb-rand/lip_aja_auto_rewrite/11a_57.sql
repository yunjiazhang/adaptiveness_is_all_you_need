SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%b%'::text) AND (mi1.info_type_id = 2)) AND ((mi1.info ~~* '%b%'::text) AND (mi1.info_type_id = 2));


/*+
NestLoop(it mc t cn mi1 ct kt ci rt n)
NestLoop(mc t cn mi1 ct kt ci rt n)
HashJoin(mc t cn mi1 ct kt ci rt)
NestLoop(mc t cn mi1 ct kt ci)
HashJoin(mc t cn mi1 ct kt)
HashJoin(mc t cn mi1 ct)
NestLoop(mc t cn mi1)
HashJoin(mc t cn)
HashJoin(mc t)
IndexScan(mi1)
IndexScan(ci)
IndexScan(n)
SeqScan(it)
SeqScan(mc)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((it ((((((((mc t) cn) mi1) ct) kt) ci) rt) n)))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(1, mc.movie_id) 
) AS mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE 
 t.id = mc.movie_id 
 AND t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND mi1.movie_id = ci.movie_id 
 AND ci.movie_id = mc.movie_id 
 AND cn.id = mc.company_id 
 AND ct.id = mc.company_type_id 
 AND kt.id = t.kind_id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND mi1.info_type_id = it.id 
 AND (kt.kind ILIKE '%v%') 
 AND (rt.role IN ('actor','cinematographer','costume designer','director','editor','guest','producer','production designer','writer')) 
 AND (t.production_year <= 1945) 
 AND (t.production_year >= 1875) 
 AND (it.id IN ('2')) 
 AND (mi1.info ILIKE '%b%') 
 AND (cn.name ILIKE '%co%') 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;