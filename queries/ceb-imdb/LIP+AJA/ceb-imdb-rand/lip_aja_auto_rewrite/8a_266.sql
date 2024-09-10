SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm","PFM:35 mm","RAT:1.33 : 1","RAT:2.35 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm","PFM:35 mm","RAT:1.33 : 1","RAT:2.35 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = ANY ('{f,m}'::text[])) OR (n.gender IS NULL)) AND (((n.name_pcode_nf)::text = ANY ('{A5242,B4325,C6235,C6545,G6431,J252,K3652,M2346,M6216,R1624,R1634,R2632}'::text[])) OR (n.name_pcode_nf IS NULL)));


/*+
HashJoin(cn mc ct t kt mi1 ci rt it1 n mk k)
NestLoop(cn mc ct t kt mi1 ci rt it1 n mk)
HashJoin(cn mc ct t kt mi1 ci rt it1 n)
HashJoin(cn mc ct t kt mi1 ci rt it1)
HashJoin(cn mc ct t kt mi1 ci rt)
NestLoop(cn mc ct t kt mi1 ci)
NestLoop(cn mc ct t kt mi1)
HashJoin(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(ci)
IndexScan(rt)
IndexScan(mk)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
Leading((((((((((((cn mc) ct) t) kt) mi1) ci) rt) it1) n) mk) k))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
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
movie_keyword as mk,
keyword as k,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
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
 AND (it1.id IN ('7')) 
 AND (mi1.info in ('OFM:35 mm','PFM:35 mm','RAT:1.33 : 1','RAT:2.35 : 1')) 
 AND (kt.kind in ('episode','movie')) 
 AND (rt.role in ('actor','actress','miscellaneous crew')) 
 AND (n.gender in ('f','m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('A5242','B4325','C6235','C6545','G6431','J252','K3652','M2346','M6216','R1624','R1634','R2632') OR n.name_pcode_nf IS NULL) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (cn.name in ('ABS-CBN','Fox Network','Sony Pictures Home Entertainment','Warner Bros. Television')) 
 AND (ct.kind in ('distributors','production companies')) 
  
;