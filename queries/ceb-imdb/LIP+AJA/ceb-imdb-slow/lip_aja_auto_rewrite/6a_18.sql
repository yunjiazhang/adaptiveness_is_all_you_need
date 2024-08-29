SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE (mi1.info = ANY ('{Australia,Canada,"Hong Kong",Mexico,"OFM:16 mm","PFM:16 mm",Philippines,"RAT:1.66 : 1","RAT:1.85 : 1","Soviet Union",Spain,Turkey,"West Germany",Yugoslavia}'::text[])) AND (mi1.info = ANY ('{Australia,Canada,"Hong Kong",Mexico,"OFM:16 mm","PFM:16 mm",Philippines,"RAT:1.66 : 1","RAT:1.85 : 1","Soviet Union",Spain,Turkey,"West Germany",Yugoslavia}'::text[]));
SELECT sum(pg_lip_bloom_add(2, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 37);
SELECT sum(pg_lip_bloom_add(3, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND ((n.name_pcode_nf)::text = ANY ('{B6524,D1352,G6252,J25,J5235,M2412,M2423,M2424,M6241,M6252,M6352,S3153,W4125,W4361,W4525}'::text[])));


/*+
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n it5)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3)
NestLoop(mii2 mii1 t ci rt mi1 kt it1)
NestLoop(mii2 mii1 t ci rt mi1 kt)
NestLoop(mii2 mii1 t ci rt mi1)
NestLoop(mii2 mii1 t ci rt)
NestLoop(mii2 mii1 t ci)
NestLoop(mii2 mii1 t)
NestLoop(mii2 mii1)
IndexScan(mii1)
IndexScan(mi1)
IndexScan(it1)
IndexScan(pi1)
SeqScan(mii2)
IndexScan(ci)
IndexScan(rt)
IndexScan(kt)
IndexScan(an)
IndexScan(t)
SeqScan(it3)
SeqScan(it4)
IndexScan(n)
SeqScan(it5)
Leading((((((((((((((mii2 mii1) t) ci) rt) mi1) kt) it1) it3) it4) pi1) an) n) it5))
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
   AND mii2.movie_id = mii1.movie_id 
   AND mi1.movie_id = mii1.movie_id 
   AND mi1.info_type_id = it1.id 
   AND mii1.info_type_id = it3.id 
   AND mii2.info_type_id = it4.id 
   AND t.kind_id = kt.id 
   AND (kt.kind IN ('episode', 
                    'movie')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
   AND (mi1.info IN ('Australia', 
                     'Canada', 
                     'Hong Kong', 
                     'Mexico', 
                     'OFM:16 mm', 
                     'PFM:16 mm', 
                     'Philippines', 
                     'RAT:1.66 : 1', 
                     'RAT:1.85 : 1', 
                     'Soviet Union', 
                     'Spain', 
                     'Turkey', 
                     'West Germany', 
                     'Yugoslavia')) 
   AND (it1.id IN ('7', 
                   '8', 
                   '9')) 
   AND it3.id = '100' 
   AND it4.id = '101' 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii2.info::float <= 5.0) 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 2.0 <= mii2.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii1.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii1.info::float <= 10000.0) 
   AND n.id = ci.person_id 
   AND ci.person_id = pi1.person_id 
   AND it5.id = pi1.info_type_id 
   AND n.id = pi1.person_id 
   AND n.id = an.person_id 
   AND ci.person_id = an.person_id 
   AND an.person_id = pi1.person_id 
   AND rt.id = ci.role_id 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (n.name_pcode_nf IN ('B6524', 
                            'D1352', 
                            'G6252', 
                            'J25', 
                            'J5235', 
                            'M2412', 
                            'M2423', 
                            'M2424', 
                            'M6241', 
                            'M6252', 
                            'M6352', 
                            'S3153', 
                            'W4125', 
                            'W4361', 
                            'W4525')) 
   AND (ci.note IS NULL) 
   AND (rt.role IN ('actor')) 
   AND (it5.id IN ('37')) 
;