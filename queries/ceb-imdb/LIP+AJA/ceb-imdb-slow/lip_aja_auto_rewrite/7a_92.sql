SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{90,USA:30}'::text[])) AND (mi1.info_type_id = 1)) AND ((mi1.info = ANY ('{90,USA:30}'::text[])) AND (mi1.info_type_id = 1));
SELECT sum(pg_lip_bloom_add(2, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 37);
SELECT sum(pg_lip_bloom_add(3, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND ((n.name_pcode_nf)::text = ANY ('{A4152,D1324,D5432,G6252,J5163,J5245,M2424,M2453,P3635,P3652,S3153}'::text[])));


/*+
HashJoin(mii2 mii1 t mk ci rt an pi1 n mi1 kt it1 it3 it4 k it5)
NestLoop(mii2 mii1 t mk ci rt an pi1 n mi1 kt it1 it3 it4 k)
HashJoin(mii2 mii1 t mk ci rt an pi1 n mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t mk ci rt an pi1 n mi1 kt it1 it3)
HashJoin(mii2 mii1 t mk ci rt an pi1 n mi1 kt it1)
NestLoop(mii2 mii1 t mk ci rt an pi1 n mi1 kt)
NestLoop(mii2 mii1 t mk ci rt an pi1 n mi1)
HashJoin(mii2 mii1 t mk ci rt an pi1 n)
HashJoin(mii2 mii1 t mk ci rt an pi1)
HashJoin(mii2 mii1 t mk ci rt an)
HashJoin(mii2 mii1 t mk ci rt)
NestLoop(mii2 mii1 t mk ci)
NestLoop(mii2 mii1 t mk)
NestLoop(mii2 mii1 t)
NestLoop(mii2 mii1)
IndexScan(mii1)
IndexScan(pi1)
IndexScan(mi1)
SeqScan(mii2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(an)
IndexScan(kt)
IndexScan(t)
IndexScan(n)
SeqScan(it1)
SeqScan(it3)
SeqScan(it4)
IndexScan(k)
SeqScan(it5)
Leading((((((((((((((((mii2 mii1) t) mk) ci) rt) an) pi1) n) mi1) kt) it1) it3) it4) k) it5))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
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
pg_lip_bloom_probe(1, ci.movie_id)  AND pg_lip_bloom_probe(2, ci.person_id)  AND pg_lip_bloom_probe(3, ci.person_id) 
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
   AND (kt.kind IN ('episode', 
                    'movie')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
   AND (mi1.info IN ('90', 
                     'USA:30')) 
   AND (it1.id IN ('1')) 
   AND it3.id = '100' 
   AND it4.id = '101' 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii2.info::float <= 8.0) 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii2.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 1000.0 <= mii1.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii1.info::float <= 10000.0) 
   AND n.id = ci.person_id 
   AND ci.person_id = pi1.person_id 
   AND it5.id = pi1.info_type_id 
   AND n.id = pi1.person_id 
   AND n.id = an.person_id 
   AND rt.id = ci.role_id 
   AND (n.gender IN ('m')) 
   AND (n.name_pcode_nf IN ('A4152', 
                            'D1324', 
                            'D5432', 
                            'G6252', 
                            'J5163', 
                            'J5245', 
                            'M2424', 
                            'M2453', 
                            'P3635', 
                            'P3652', 
                            'S3153')) 
   AND (ci.note IS NULL) 
   AND (rt.role IN ('actor')) 
   AND (it5.id IN ('37')) 
;