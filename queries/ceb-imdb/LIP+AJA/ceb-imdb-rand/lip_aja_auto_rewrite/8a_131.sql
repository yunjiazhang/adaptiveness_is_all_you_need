SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:Atp,Australia:M,Canada:G,Canada:PG,Finland:S,Germany:12,Sweden:Btl,UK:U,USA:Passed,"West Germany:12"}'::text[]))) AND ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Argentina:Atp,Australia:M,Canada:G,Canada:PG,Finland:S,Germany:12,Sweden:Btl,UK:U,USA:Passed,"West Germany:12"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND (((n.name_pcode_nf)::text = ANY ('{C6231,C6235,C6425,C6426,F6524,J5265,M6216,R1635,R1636,S3152}'::text[])) OR (n.name_pcode_nf IS NULL)));


/*+
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n k)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt)
HashJoin(cn mc ct t kt mk mi1 it1 ci)
HashJoin(cn mc ct t kt mk mi1 it1)
HashJoin(cn mc ct t kt mk mi1)
NestLoop(cn mc ct t kt mk)
NestLoop(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(kt)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
Leading((((((((((((cn mc) ct) t) kt) mk) mi1) it1) ci) rt) n) k))
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
pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
role_type as rt,
name as n,
(
    SELECT * FROM movie_keyword as mk
    WHERE 
pg_lip_bloom_probe(1, mk.movie_id) 
) AS mk,
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
 AND (mi1.info in ('Argentina:Atp','Australia:M','Canada:G','Canada:PG','Finland:S','Germany:12','Sweden:Btl','UK:U','USA:Passed','West Germany:12')) 
 AND (kt.kind in ('movie')) 
 AND (rt.role in ('actor','director','miscellaneous crew')) 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('C6231','C6235','C6425','C6426','F6524','J5265','M6216','R1635','R1636','S3152') OR n.name_pcode_nf IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (cn.name in ('Columbia Broadcasting System (CBS)','Metro-Goldwyn-Mayer (MGM)','Warner Home Video')) 
 AND (ct.kind in ('distributors','production companies')) 
  
;