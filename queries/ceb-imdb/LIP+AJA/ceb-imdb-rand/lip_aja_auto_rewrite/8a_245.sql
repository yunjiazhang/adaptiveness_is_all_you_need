SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA"}'::text[])));


/*+
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n k)
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
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
(
    SELECT * FROM movie_keyword as mk
    WHERE 
pg_lip_bloom_probe(1, mk.movie_id) 
) AS mk,
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
 AND (mi1.info in ('CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA','New York City, New York, USA')) 
 AND (kt.kind in ('episode','movie')) 
 AND (rt.role in ('actor','cinematographer','miscellaneous crew','production designer')) 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (n.surname_pcode in ('B2','C2','C45','C5','D5','M2','M25','M625','O425','P62') OR n.surname_pcode IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (cn.name in ('Columbia Broadcasting System (CBS)','Metro-Goldwyn-Mayer (MGM)','Universal Pictures','Warner Home Video')) 
 AND (ct.kind in ('distributors','production companies')) 
  
;