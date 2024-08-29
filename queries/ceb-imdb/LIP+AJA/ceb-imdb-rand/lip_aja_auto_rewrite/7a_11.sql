SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE (mi1.info = ANY ('{OFM:Video,"PFM:35 mm","RAT:1.78 : 1"}'::text[])) AND (mi1.info = ANY ('{OFM:Video,"PFM:35 mm","RAT:1.78 : 1"}'::text[]));
SELECT sum(pg_lip_bloom_add(2, pi1.person_id)) FROM person_info AS pi1 
        WHERE (pi1.info_type_id = 32);
SELECT sum(pg_lip_bloom_add(3, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = ANY ('{f,m}'::text[])) OR (n.gender IS NULL)) AND (((n.name_pcode_nf)::text = ANY ('{A4253,A5362,B6535,C6231,E4213,F6521,F6525,K6235,R1631,R1632,R2632,S3152}'::text[])) OR (n.name_pcode_nf IS NULL)));


/*+
HashJoin(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 mk k an n it5)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 mk k an n)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 mk k an)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 mk k)
NestLoop(mii2 mii1 t ci rt pi1 mi1 kt it1 it3 it4 mk)
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
IndexScan(mk)
IndexScan(an)
IndexScan(t)
SeqScan(it3)
SeqScan(it4)
IndexScan(k)
IndexScan(n)
SeqScan(it5)
Leading((((((((((((((((mii2 mii1) t) ci) rt) pi1) mi1) kt) it1) it3) it4) mk) k) an) n) it5))
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
 AND t.id = mk.movie_id 
 AND mk.keyword_id = k.id 
 AND mi1.info_type_id = it1.id 
 AND mii1.info_type_id = it3.id 
 AND mii2.info_type_id = it4.id 
 AND t.kind_id = kt.id 
 AND (kt.kind IN ('tv movie','video movie')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
 AND (mi1.info IN ('OFM:Video','PFM:35 mm','RAT:1.78 : 1')) 
 AND (it1.id IN ('106','7','98')) 
 AND it3.id = '100' 
 AND it4.id = '101' 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0) 
 AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 5000.0 <= mii1.info::float) 
 AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 500000.0) 
 AND n.id = ci.person_id 
 AND ci.person_id = pi1.person_id 
 AND it5.id = pi1.info_type_id 
 AND n.id = pi1.person_id 
 AND n.id = an.person_id 
 AND rt.id = ci.role_id 
 AND (n.gender in ('f','m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('A4253','A5362','B6535','C6231','E4213','F6521','F6525','K6235','R1631','R1632','R2632','S3152') OR n.name_pcode_nf IS NULL) 
 AND (ci.note IS NULL) 
 AND (rt.role in ('actor','actress')) 
 AND (it5.id in ('32')) 
  
;