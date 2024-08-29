SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%p%'::text) AND (mi1.info_type_id = 5)) AND ((mi1.info ~~* '%p%'::text) AND (mi1.info_type_id = 5));


/*+
NestLoop(it mc cn t mi1 ct kt ci rt n)
NestLoop(mc cn t mi1 ct kt ci rt n)
HashJoin(mc cn t mi1 ct kt ci rt)
NestLoop(mc cn t mi1 ct kt ci)
HashJoin(mc cn t mi1 ct kt)
HashJoin(mc cn t mi1 ct)
NestLoop(mc cn t mi1)
NestLoop(mc cn t)
HashJoin(mc cn)
IndexScan(mi1)
IndexScan(ci)
IndexScan(t)
IndexScan(n)
SeqScan(it)
SeqScan(mc)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
SeqScan(rt)
Leading((it ((((((((mc cn) t) mi1) ct) kt) ci) rt) n)))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
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
 AND (kt.kind ILIKE '%m%') 
 AND (rt.role IN ('actor','actress','composer','editor','miscellaneous crew','producer')) 
 AND (t.production_year <= 1945) 
 AND (t.production_year >= 1875) 
 AND (it.id IN ('5')) 
 AND (mi1.info ILIKE '%p%') 
 AND (cn.name ILIKE '%un%') 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;