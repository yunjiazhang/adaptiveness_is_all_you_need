SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2)) AND ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((n.gender IS NULL) AND ((n.name_pcode_cf)::text = ANY ('{A2365,B5242,D1614,E1524,L1214,L2,P3625,P5215,Q5325,R2425,R25,R3626,S3152,S5325,T5212}'::text[])));


/*+
NestLoop(cn mc ct t kt mi1 ci rt n it1 mk k)
NestLoop(cn mc ct t kt mi1 ci rt n it1 mk)
HashJoin(cn mc ct t kt mi1 ci rt n it1)
NestLoop(cn mc ct t kt mi1 ci rt n)
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
IndexScan(n)
SeqScan(it1)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
Leading((((((((((((cn mc) ct) t) kt) mi1) ci) rt) n) it1) mk) k))
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
   AND (it1.id IN ('2')) 
   AND (mi1.info IN ('Black AND White', 
                     'Color')) 
   AND (kt.kind IN ('movie', 
                    'tv movie', 
                    'tv series')) 
   AND (rt.role IN ('composer', 
                    'editor', 
                    'miscellaneous crew', 
                    'producer', 
                    'production designer')) 
   AND (n.gender IS NULL) 
   AND (n.name_pcode_cf IN ('A2365', 
                            'B5242', 
                            'D1614', 
                            'E1524', 
                            'L1214', 
                            'L2', 
                            'P3625', 
                            'P5215', 
                            'Q5325', 
                            'R2425', 
                            'R25', 
                            'R3626', 
                            'S3152', 
                            'S5325', 
                            'T5212')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
   AND (cn.name IN ('20th Century Fox Television', 
                    'ABS-CBN', 
                    'American Broadcasting Company (ABC)', 
                    'British Broadcasting Corporation (BBC)', 
                    'Granada Television', 
                    'National Broadcasting Company (NBC)', 
                    'Warner Bros. Television', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;