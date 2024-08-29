SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA","Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA","Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND ((n.name_pcode_cf)::text = ANY ('{A5362,B6261,D1232,M6352,O4252,R1632,S3152,S5362}'::text[])));


/*+
NestLoop(cn mc ct t kt mk mi1 it1 ci rt n k)
NestLoop(cn mc ct t kt mk mi1 it1 ci rt n)
NestLoop(cn mc ct t kt mk mi1 it1 ci rt)
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
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
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
 AND (mi1.info in ('CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','New York City, New York, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
 AND (kt.kind in ('episode')) 
 AND (rt.role in ('actor','producer')) 
 AND (n.gender in ('m')) 
 AND (n.name_pcode_cf in ('A5362','B6261','D1232','M6352','O4252','R1632','S3152','S5362')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (cn.name in ('American Broadcasting Company (ABC)','Columbia Broadcasting System (CBS)','National Broadcasting Company (NBC)')) 
 AND (ct.kind in ('distributors')) 
  
;