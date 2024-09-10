SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{Argentina:13,Australia:M}'::text[])) AND (mi1.info_type_id = 5)) AND ((mi1.info = ANY ('{Argentina:13,Australia:M}'::text[])) AND (mi1.info_type_id = 5));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND ((n.name_pcode_cf)::text = ANY ('{A4361,B6526,M6256,M6352,P6252,R1525,R2632,S3152,S4153,S5362}'::text[])));


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
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
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
(
    SELECT * FROM movie_keyword AS mk
    WHERE 
pg_lip_bloom_probe(1, mk.movie_id) 
) AS mk,
keyword AS k,
movie_companies AS mc,
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
   AND (it1.id IN ('5')) 
   AND (mi1.info IN ('Argentina:13', 
                     'Australia:M')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('actor', 
                    'director', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (n.name_pcode_cf IN ('A4361', 
                            'B6526', 
                            'M6256', 
                            'M6352', 
                            'P6252', 
                            'R1525', 
                            'R2632', 
                            'S3152', 
                            'S4153', 
                            'S5362')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
   AND (cn.name IN ('British Broadcasting Corporation (BBC)', 
                    'Columbia Broadcasting System (CBS)', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;