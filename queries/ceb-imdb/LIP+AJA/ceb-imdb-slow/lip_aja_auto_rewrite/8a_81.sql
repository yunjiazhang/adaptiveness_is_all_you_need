SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm",OFM:Video,PCS:Spherical,"PFM:35 mm",PFM:Video,"RAT:1.33 : 1","RAT:1.78 : 1","RAT:16:9 HD","RAT:2.35 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm",OFM:Video,PCS:Spherical,"PFM:35 mm",PFM:Video,"RAT:1.33 : 1","RAT:1.78 : 1","RAT:16:9 HD","RAT:2.35 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'f'::text) AND ((n.name_pcode_nf)::text = ANY ('{A4253,B1642,C6452,J2452,J5165,K3451,L5326,M4532,P3621}'::text[])));


/*+
HashJoin(cn mc ct t kt mi1 ci rt n it1 mk k)
NestLoop(cn mc ct t kt mi1 ci rt n it1 mk)
HashJoin(cn mc ct t kt mi1 ci rt n it1)
HashJoin(cn mc ct t kt mi1 ci rt n)
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
   AND (it1.id IN ('7')) 
   AND (mi1.info IN ('OFM:35 mm', 
                     'OFM:Video', 
                     'PCS:Spherical', 
                     'PFM:35 mm', 
                     'PFM:Video', 
                     'RAT:1.33 : 1', 
                     'RAT:1.78 : 1', 
                     'RAT:16:9 HD', 
                     'RAT:2.35 : 1')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('actress', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('f')) 
   AND (n.name_pcode_nf IN ('A4253', 
                            'B1642', 
                            'C6452', 
                            'J2452', 
                            'J5165', 
                            'K3451', 
                            'L5326', 
                            'M4532', 
                            'P3621')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
   AND (cn.name IN ('20th Century Fox Television', 
                    'ABS-CBN', 
                    'American Broadcasting Company (ABC)', 
                    'British Broadcasting Corporation (BBC)', 
                    'Columbia Broadcasting System (CBS)', 
                    'Granada Television', 
                    'National Broadcasting Company (NBC)', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;