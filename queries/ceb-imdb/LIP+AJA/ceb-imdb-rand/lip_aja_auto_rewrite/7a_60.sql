SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(5);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE (mi1.info = 'Black AND White'::text) AND (mi1.info = 'Black AND White'::text);
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = ANY ('{f,m}'::text[])) OR (n.gender IS NULL)) AND ((n.name_pcode_nf)::text = ANY ('{A4253,A5141,A5253,A5363,A5365,B1626,B6523,C6235,G1642,G6256,J5214,J526,L6524,S525,W4125}'::text[])));
SELECT sum(pg_lip_bloom_add(3, pi1.person_id)), sum(pg_lip_bloom_add(4, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 34) AND (pi1.info_type_id = 34);


/*+
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 mk k an pi1 it5)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 mk k an pi1)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 mk k an)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 mk k)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 mk)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1 it3)
NestLoop(mii2 mii1 t ci rt n mi1 kt it1)
NestLoop(mii2 mii1 t ci rt n mi1 kt)
NestLoop(mii2 mii1 t ci rt n mi1)
NestLoop(mii2 mii1 t ci rt n)
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
IndexScan(mk)
IndexScan(an)
IndexScan(t)
IndexScan(n)
SeqScan(it3)
SeqScan(it4)
IndexScan(k)
SeqScan(it5)
Leading((((((((((((((((mii2 mii1) t) ci) rt) n) mi1) kt) it1) it3) it4) mk) k) an) pi1) it5))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
(
    SELECT * FROM name as n
    WHERE 
pg_lip_bloom_probe(4, n.id) 
) AS n,
info_type as it5,
person_info as pi1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id)  AND pg_lip_bloom_probe(2, ci.person_id)  AND pg_lip_bloom_probe(3, ci.person_id) 
) AS ci,
role_type as rt
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
 AND (kt.kind IN ('episode','movie')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (mi1.info IN ('Black AND White')) 
 AND (it1.id IN ('13','2')) 
 AND it3.id = '100' 
 AND it4.id = '101' 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 8.0) 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 5000.0 <= mii1.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 500000.0) 
 AND n.id = ci.person_id 
 AND ci.person_id = pi1.person_id 
 AND it5.id = pi1.info_type_id 
 AND n.id = pi1.person_id 
 AND n.id = an.person_id 
 AND rt.id = ci.role_id 
 AND (n.gender in ('f','m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('A4253','A5141','A5253','A5363','A5365','B1626','B6523','C6235','G1642','G6256','J5214','J526','L6524','S525','W4125')) 
 AND (ci.note in ('(executive producer)','(writer)') OR ci.note IS NULL) 
 AND (rt.role in ('actor','actress','editor','producer','writer')) 
 AND (it5.id in ('34')) 
  
;