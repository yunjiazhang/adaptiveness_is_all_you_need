SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE (mi1.info = ANY ('{"Dolby Digital","Dolby SR",Dolby,"Los Angeles, California, USA","New York City, New York, USA",Stereo}'::text[])) AND (mi1.info = ANY ('{"Dolby Digital","Dolby SR",Dolby,"Los Angeles, California, USA","New York City, New York, USA",Stereo}'::text[]));
SELECT sum(pg_lip_bloom_add(2, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 34);
SELECT sum(pg_lip_bloom_add(3, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND ((n.name_pcode_nf)::text = ANY ('{A4163,A4236,D5234,G6256,J1626,J2165,J23,M2463,M6232,M6261,M6262,O4161,T6235}'::text[])));


/*+
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n it5)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3)
HashJoin(mii2 mii1 t ci rt mi1 kt it1)
HashJoin(mii2 mii1 t ci rt mi1 kt)
HashJoin(mii2 mii1 t ci rt mi1)
HashJoin(mii2 mii1 t ci rt)
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
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
   AND (mi1.info IN ('Dolby Digital', 
                     'Dolby SR', 
                     'Dolby', 
                     'Los Angeles, California, USA', 
                     'New York City, New York, USA', 
                     'Stereo')) 
   AND (it1.id IN ('18', 
                   '6', 
                   '97')) 
   AND it3.id = '100' 
   AND it4.id = '101' 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii2.info::float <= 8.0) 
   AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii2.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND 0.0 <= mii1.info::float) 
   AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' 
        AND mii1.info::float <= 1000.0) 
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
   AND (n.name_pcode_nf IN ('A4163', 
                            'A4236', 
                            'D5234', 
                            'G6256', 
                            'J1626', 
                            'J2165', 
                            'J23', 
                            'M2463', 
                            'M6232', 
                            'M6261', 
                            'M6262', 
                            'O4161', 
                            'T6235')) 
   AND (ci.note IN ('(voice)') 
        OR ci.note IS NULL) 
   AND (rt.role IN ('actor')) 
   AND (it5.id IN ('34')) 
;