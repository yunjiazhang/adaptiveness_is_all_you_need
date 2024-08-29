SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info ~~* '%dts%'::text) AND (mi1.info_type_id = 6));


/*+
HashJoin(cn mc mi1 ci t ct kt n rt it)
NestLoop(cn mc mi1 ci t ct kt n rt)
NestLoop(cn mc mi1 ci t ct kt n)
NestLoop(cn mc mi1 ci t ct kt)
NestLoop(cn mc mi1 ci t ct)
NestLoop(cn mc mi1 ci t)
NestLoop(cn mc mi1 ci)
NestLoop(cn mc mi1)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(ci)
IndexScan(ct)
IndexScan(kt)
IndexScan(rt)
IndexScan(t)
IndexScan(n)
SeqScan(cn)
SeqScan(it)
Leading((((((((((cn mc) mi1) ci) t) ct) kt) n) rt) it))
*/
 SELECT n.gender, rt.role, cn.name, COUNT(*) 
 
FROM 
title as t,
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
 AND (rt.role IN ('actress','cinematographer','director','guest','miscellaneous crew','producer','production designer','writer')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1875) 
 AND (it.id IN ('6')) 
 AND (mi1.info ILIKE '%dts%') 
 AND (cn.name ILIKE '%bill%') 
 GROUP BY n.gender, rt.role, cn.name 
 ORDER BY COUNT(*) DESC 
  
;