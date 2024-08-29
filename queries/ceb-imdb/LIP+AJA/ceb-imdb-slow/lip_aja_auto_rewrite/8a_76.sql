SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 8) AND (mi1.info = 'USA'::text)) AND ((mi1.info_type_id = 8) AND (mi1.info = 'USA'::text));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND ((n.name_pcode_nf)::text = ANY ('{A4163,B1614,C6231,J252,J5252,R1632}'::text[])));


/*+
NestLoop(cn mc ct t kt mi1 mk ci rt it1 n k)
HashJoin(cn mc ct t kt mi1 mk ci rt it1 n)
HashJoin(cn mc ct t kt mi1 mk ci rt it1)
HashJoin(cn mc ct t kt mi1 mk ci rt)
NestLoop(cn mc ct t kt mi1 mk ci)
NestLoop(cn mc ct t kt mi1 mk)
NestLoop(cn mc ct t kt mi1)
HashJoin(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
Leading((((((((((((cn mc) ct) t) kt) mi1) mk) ci) rt) it1) n) k))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
role_type AS rt,
name AS n,
movie_keyword AS mk,
keyword AS k,
(
    SELECT * FROM movie_companies AS mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
company_type AS ct,
company_name AS cn
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
   AND (it1.id IN ('8')) 
   AND (mi1.info IN ('USA')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('actor', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('m')) 
   AND (n.name_pcode_nf IN ('A4163', 
                            'B1614', 
                            'C6231', 
                            'J252', 
                            'J5252', 
                            'R1632')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1975) 
   AND (cn.name IN ('ABS-CBN', 
                    'Fox Network', 
                    'Granada Television', 
                    'Sony Pictures Home Entertainment', 
                    'Warner Bros. Television')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;