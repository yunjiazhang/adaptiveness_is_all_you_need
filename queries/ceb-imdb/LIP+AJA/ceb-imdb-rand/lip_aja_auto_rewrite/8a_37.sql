SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Crime,Documentary,Romance}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Crime,Documentary,Romance}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = ANY ('{f,m}'::text[])) OR (n.gender IS NULL)) AND ((n.name_pcode_cf)::text = ANY ('{A5362,B4525,B6261,D1232,P5235,R1632,R363,S3152,W5165}'::text[])));


/*+
NestLoop(cn mc ct t kt mk mi1 it1 ci rt n k)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt)
NestLoop(cn mc ct t kt mk mi1 it1 ci)
HashJoin(cn mc ct t kt mk mi1 it1)
NestLoop(cn mc ct t kt mk mi1)
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
 AND (it1.id IN ('3')) 
 AND (mi1.info in ('Crime','Documentary','Romance')) 
 AND (kt.kind in ('movie','tv movie')) 
 AND (rt.role in ('actor','actress','producer')) 
 AND (n.gender in ('f','m') OR n.gender IS NULL) 
 AND (n.name_pcode_cf in ('A5362','B4525','B6261','D1232','P5235','R1632','R363','S3152','W5165')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (cn.name in ('British Broadcasting Corporation (BBC)','Columbia Broadcasting System (CBS)','Warner Home Video')) 
 AND (ct.kind in ('distributors','production companies')) 
  
;