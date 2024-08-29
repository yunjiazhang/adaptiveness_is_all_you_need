SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn 
        WHERE ((cn.country_code)::text = ANY ('{[au],[nl],[ph],[ru]}'::text[]));


/*+
NestLoop(rt k mk t kt mc ct cn ci n)
NestLoop(rt k mk t kt mc ct cn ci)
NestLoop(k mk t kt mc ct cn ci)
NestLoop(k mk t kt mc ct cn)
HashJoin(k mk t kt mc ct)
NestLoop(k mk t kt mc)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mk)
IndexScan(mc)
IndexScan(cn)
IndexScan(ci)
IndexScan(t)
IndexScan(n)
SeqScan(rt)
SeqScan(kt)
SeqScan(ct)
SeqScan(k)
Leading(((rt (((((((k mk) t) kt) mc) ct) cn) ci)) n))
*/
 SELECT COUNT(*) 
FROM 
title as t,
movie_keyword as mk,
keyword as k,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.company_id) 
) AS mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE 
 t.id = mk.movie_id 
 AND t.id = mc.movie_id 
 AND t.id = ci.movie_id 
 AND ci.movie_id = mc.movie_id 
 AND ci.movie_id = mk.movie_id 
 AND mk.movie_id = mc.movie_id 
 AND k.id = mk.keyword_id 
 AND cn.id = mc.company_id 
 AND ct.id = mc.company_type_id 
 AND kt.id = t.kind_id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (k.keyword IN ('collaborative-filmmaking','corpse-in-a-coffin','escape-jail','ghost-train','head-caught-in-venetian-blinds','japanese-citizens','lambada','lost-lease','reference-to-tom-hayden','spear-thrower','under-tipping','wolf-boy','worst-case-scenario')) 
 AND (cn.country_code IN ('[au]','[nl]','[ph]','[ru]')) 
 AND (ct.kind IN ('distributors','production companies')) 
 AND (kt.kind IN ('episode','movie','tv movie')) 
 AND (rt.role IN ('editor')) 
 AND (n.gender IN ('m')) 
  
;