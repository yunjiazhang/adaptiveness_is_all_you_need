SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE (mi1.info = 'Silent'::text) AND (mi1.info = 'Silent'::text);
SELECT sum(pg_lip_bloom_add(2, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 34);
SELECT sum(pg_lip_bloom_add(3, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND ((n.name_pcode_nf)::text = ANY ('{A6362,B6563,E3632,F6362,F6523,F6524,F6526,F6532,G6216,H6163,R1635,R1636,R2632,S2534,W4362}'::text[])));


/*+
HashJoin(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 an n it5)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 an n)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 an)
HashJoin(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t ci rt pi1 mi1 kt it1 it3)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt)
NestLoop(mii2 mii1 t ci rt pi1 mi1)
NestLoop(mii2 mii1 t ci rt pi1)
NestLoop(mii2 mii1 t ci rt)
NestLoop(mii2 mii1 t ci)
NestLoop(mii2 mii1 t)
NestLoop(mii2 mii1)
IndexScan(mii1)
IndexScan(pi1)
IndexScan(mi1)
IndexScan(it1)
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
Leading((((((((((((((mii2 mii1) t) ci) rt) pi1) mi1) kt) it1) it3) it4) an) n) it5))
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
aka_name as an,
name as n,
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
 AND mii2.movie_id = mii1.movie_id 
 AND mi1.movie_id = mii1.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mii1.info_type_id = it3.id 
 AND mii2.info_type_id = it4.id 
 AND t.kind_id = kt.id 
 AND (kt.kind IN ('movie')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (mi1.info IN ('Silent')) 
 AND (it1.id IN ('15','6','94')) 
 AND it3.id = '100' 
 AND it4.id = '101' 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0) 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0) 
 AND n.id = ci.person_id 
 AND ci.person_id = pi1.person_id 
 AND it5.id = pi1.info_type_id 
 AND n.id = pi1.person_id 
 AND n.id = an.person_id 
 AND ci.person_id = an.person_id 
 AND an.person_id = pi1.person_id 
 AND rt.id = ci.role_id 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('A6362','B6563','E3632','F6362','F6523','F6524','F6526','F6532','G6216','H6163','R1635','R1636','R2632','S2534','W4362')) 
 AND (ci.note in ('(producer)','(uncredited)') OR ci.note IS NULL) 
 AND (rt.role in ('actor','producer')) 
 AND (it5.id in ('34')) 
  
;