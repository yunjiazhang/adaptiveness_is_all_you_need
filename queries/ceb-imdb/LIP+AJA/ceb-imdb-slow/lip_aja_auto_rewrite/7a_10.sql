SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 34);
SELECT sum(pg_lip_bloom_add(1, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND ((n.name_pcode_nf)::text = ANY ('{C6421,C6423,C6424,F6524,F6532,R1631,R2632}'::text[])));


/*+
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3 it4 k an n it5)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3 it4 k an n)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3 it4 k an)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3 it4 k)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1 it3)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt it1)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1 kt)
HashJoin(mii2 mii1 t mk ci rt pi1 mi1)
HashJoin(mii2 mii1 t mk ci rt pi1)
HashJoin(mii2 mii1 t mk ci rt)
NestLoop(mii2 mii1 t mk ci)
NestLoop(mii2 mii1 t mk)
NestLoop(mii2 mii1 t)
NestLoop(mii2 mii1)
IndexScan(mii1)
IndexScan(pi1)
IndexScan(mi1)
IndexScan(it1)
SeqScan(mii2)
IndexScan(mk)
IndexScan(ci)
IndexScan(kt)
IndexScan(an)
IndexScan(t)
SeqScan(it3)
SeqScan(it4)
IndexScan(k)
IndexScan(n)
SeqScan(it5)
SeqScan(rt)
Leading((((((((((((((((mii2 mii1) t) mk) ci) rt) pi1) mi1) kt) it1) it3) it4) k) an) n) it5))
*/
 SELECT COUNT(*) 
 
FROM 
title AS t,
movie_info AS mi1,
kind_type AS kt,
info_type AS it1,
info_type AS it3,
info_type AS it4,
movie_info_idx AS mii1,
movie_info_idx AS mii2,
movie_keyword AS mk,
keyword AS k,
aka_name AS an,
name AS n,
info_type AS it5,
person_info AS pi1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id)  AND pg_lip_bloom_probe(1, ci.person_id) 
) AS ci,
role_type AS rt
WHERE 
 t.id = mi1.movie_id 
   AND t.id = ci.movie_id 
   AND t.id = mii1.movie_id 
   AND t.id = mii2.movie_id 
   AND t.id = mk.movie_id 
   AND mk.keyword_id = k.id 
   AND mi1.info_type_id = it1.id 
   AND mii1.info_type_id = it3.id 
   AND mii2.info_type_id = it4.id 
   AND t.kind_id = kt.id 
   AND (kt.kind IN ('movie')) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1925) 
   AND (mi1.info IN ('Animation', 
                     'Comedy', 
                     'Crime', 
                     'Documentary', 
                     'Drama', 
                     'Romance', 
                     'Short')) 
   AND (it1.id IN ('3', 
                   '9')) 
   AND it3.id = '100' 
   AND it4.id = '101' 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii2.info::float <= 8.0) 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii2.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii1.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii1.info::float <= 10000.0) 
   AND n.id = ci.person_id 
   AND ci.person_id = pi1.person_id 
   AND it5.id = pi1.info_type_id 
   AND n.id = pi1.person_id 
   AND n.id = an.person_id 
   AND rt.id = ci.role_id 
   AND (n.gender IN ('m')) 
   AND (n.name_pcode_nf IN ('C6421', 
                            'C6423', 
                            'C6424', 
                            'F6524', 
                            'F6532', 
                            'R1631', 
                            'R2632')) 
   AND (ci.note IN ('(uncredited)') 
        OR ci.note IS NULL) 
   AND (rt.role IN ('actor')) 
   AND (it5.id IN ('34')) 
;