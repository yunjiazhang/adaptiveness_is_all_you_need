SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA","General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA","General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((((n.gender)::text = 'm'::text) OR (n.gender IS NULL)) AND ((n.name_pcode_nf)::text = ANY ('{C6231,C6235,D5216,E3241,G6252,J5162,P3625,R1632,S3152,S3521}'::text[])));


/*+
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk k)
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk)
NestLoop(cn mc ct t kt ci mi1 it1 rt n)
NestLoop(cn mc ct t kt ci mi1 it1 rt)
HashJoin(cn mc ct t kt ci mi1 it1)
NestLoop(cn mc ct t kt ci mi1)
NestLoop(cn mc ct t kt ci)
NestLoop(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
IndexScan(mk)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
Leading((((((((((((cn mc) ct) t) kt) ci) mi1) it1) rt) n) mk) k))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id)  AND pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
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
 AND (it1.id IN ('18')) 
 AND (mi1.info in ('CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA')) 
 AND (kt.kind in ('episode')) 
 AND (rt.role in ('actor','miscellaneous crew','producer','production designer')) 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (n.name_pcode_nf in ('C6231','C6235','D5216','E3241','G6252','J5162','P3625','R1632','S3152','S3521')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (cn.name in ('American Broadcasting Company (ABC)','Columbia Broadcasting System (CBS)','National Broadcasting Company (NBC)')) 
 AND (ct.kind in ('distributors')) 
  
;