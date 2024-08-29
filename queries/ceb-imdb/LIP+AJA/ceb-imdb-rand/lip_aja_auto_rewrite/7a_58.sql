SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 37);
SELECT sum(pg_lip_bloom_add(1, n.id)) FROM name AS n 
        WHERE ((n.name_pcode_nf IS NULL) AND ((n.gender)::text = 'm'::text));


/*+
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n mk k it5)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n mk k)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n mk)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an n)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1 an)
NestLoop(mii2 mii1 t ci rt mi1 kt it1 it3 it4 pi1)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3 it4)
HashJoin(mii2 mii1 t ci rt mi1 kt it1 it3)
NestLoop(mii2 mii1 t ci rt mi1 kt it1)
NestLoop(mii2 mii1 t ci rt mi1 kt)
NestLoop(mii2 mii1 t ci rt mi1)
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
IndexScan(mk)
IndexScan(t)
SeqScan(it3)
SeqScan(it4)
IndexScan(n)
IndexScan(k)
SeqScan(it5)
Leading((((((((((((((((mii2 mii1) t) ci) rt) mi1) kt) it1) it3) it4) pi1) an) n) mk) k) it5))
*/
 SELECT COUNT(*) 
 
FROM 
title as t,
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
name as n,
info_type as it5,
person_info as pi1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(0, ci.person_id)  AND pg_lip_bloom_probe(1, ci.person_id) 
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
 AND (kt.kind IN ('video movie')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
 AND (mi1.info IN ('Adult','Comedy','Documentary','Drama','Music','Short')) 
 AND (it1.id IN ('103','16','3')) 
 AND it3.id = '100' 
 AND it4.id = '101' 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0) 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0) 
 AND n.id = ci.person_id 
 AND ci.person_id = pi1.person_id 
 AND it5.id = pi1.info_type_id 
 AND n.id = pi1.person_id 
 AND n.id = an.person_id 
 AND rt.id = ci.role_id 
 AND (n.gender in ('m')) 
 AND (n.name_pcode_nf IS NULL) 
 AND (ci.note IS NULL) 
 AND (rt.role in ('actor')) 
 AND (it5.id in ('37')) 
  
;