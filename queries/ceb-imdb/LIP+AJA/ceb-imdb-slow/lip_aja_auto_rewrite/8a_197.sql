SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm",OFM:Live,PCS:Spherical,"PFM:35 mm",PFM:Video,"RAT:1.33 : 1","RAT:1.37 : 1","RAT:1.85 : 1","RAT:2.35 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"OFM:35 mm",OFM:Live,PCS:Spherical,"PFM:35 mm",PFM:Video,"RAT:1.33 : 1","RAT:1.37 : 1","RAT:1.85 : 1","RAT:2.35 : 1"}'::text[])));


/*+
HashJoin(cn mc ct t kt mi1 it1 mk ci rt n k)
HashJoin(cn mc ct t kt mi1 it1 mk ci rt n)
HashJoin(cn mc ct t kt mi1 it1 mk ci rt)
HashJoin(cn mc ct t kt mi1 it1 mk ci)
NestLoop(cn mc ct t kt mi1 it1 mk)
HashJoin(cn mc ct t kt mi1 it1)
NestLoop(cn mc ct t kt mi1)
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
Leading((((((((((((cn mc) ct) t) kt) mi1) it1) mk) ci) rt) n) k))
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
cast_info AS ci,
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
                     'OFM:Live', 
                     'PCS:Spherical', 
                     'PFM:35 mm', 
                     'PFM:Video', 
                     'RAT:1.33 : 1', 
                     'RAT:1.37 : 1', 
                     'RAT:1.85 : 1', 
                     'RAT:2.35 : 1')) 
   AND (kt.kind IN ('episode', 
                    'movie', 
                    'tv movie')) 
   AND (rt.role IN ('actress', 
                    'composer', 
                    'costume designer', 
                    'director', 
                    'miscellaneous crew', 
                    'production designer')) 
   AND (n.gender IN ('f') 
        OR n.gender IS NULL) 
   AND (n.surname_pcode IN ('B62', 
                            'B65', 
                            'H4', 
                            'J52', 
                            'L', 
                            'M6', 
                            'R2') 
        OR n.surname_pcode IS NULL) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
   AND (cn.name IN ('British Broadcasting Corporation (BBC)', 
                    'Columbia Broadcasting System (CBS)', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;