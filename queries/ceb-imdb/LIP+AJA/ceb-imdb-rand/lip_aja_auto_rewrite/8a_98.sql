SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = 'Australia:G'::text)) AND ((mi1.info_type_id = 5) AND (mi1.info = 'Australia:G'::text));


/*+
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk k)
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk)
NestLoop(cn mc ct t kt ci mi1 it1 rt n)
NestLoop(cn mc ct t kt ci mi1 it1 rt)
HashJoin(cn mc ct t kt ci mi1 it1)
NestLoop(cn mc ct t kt ci mi1)
NestLoop(cn mc ct t kt ci)
NestLoop(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
IndexScan(mk)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
Leading((((((((((((cn mc) ct) t) kt) ci) mi1) it1) rt) n) mk) k))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
) AS ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mc.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mk.movie_id 
 AND mc.company_type_id = ct.id 
 AND mc.company_id = cn.id 
 AND k.id = mk.keyword_id 
 AND mi1.info_type_id = it1.id 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (it1.id IN ('5')) 
 AND (mi1.info in ('Australia:G')) 
 AND (kt.kind in ('episode')) 
 AND (rt.role in ('cinematographer','editor','miscellaneous crew','producer','writer')) 
 AND (n.gender IS NULL) 
 AND (n.surname_pcode IS NULL) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (cn.name in ('British Broadcasting Corporation (BBC)','Columbia Broadcasting System (CBS)')) 
 AND (ct.kind in ('production companies')) 
  
;