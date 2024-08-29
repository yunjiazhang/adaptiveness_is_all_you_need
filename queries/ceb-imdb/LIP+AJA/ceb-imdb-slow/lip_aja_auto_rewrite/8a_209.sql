SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","New York City, New York, USA"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = ANY ('{f,m}'::text[])) AND ((n.name_pcode_cf)::text = ANY ('{A4361,A5362,B6261,R363,S4153}'::text[])));


/*+
NestLoop(cn mc ct t kt mk ci mi1 it1 rt n k)
NestLoop(cn mc ct t kt mk ci mi1 it1 rt n)
NestLoop(cn mc ct t kt mk ci mi1 it1 rt)
HashJoin(cn mc ct t kt mk ci mi1 it1)
NestLoop(cn mc ct t kt mk ci mi1)
NestLoop(cn mc ct t kt mk ci)
NestLoop(cn mc ct t kt mk)
NestLoop(cn mc ct t kt)
NestLoop(cn mc ct t)
NestLoop(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(ct)
IndexScan(kt)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
Leading((((((((((((cn mc) ct) t) kt) mk) ci) mi1) it1) rt) n) k))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id)  AND pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
role_type AS rt,
name AS n,
movie_keyword AS mk,
keyword AS k,
movie_companies AS mc,
company_type AS ct,
company_name AS cn
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
   AND (mi1.info IN ('CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA', 
                     'Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA', 
                     'New York City, New York, USA')) 
   AND (kt.kind IN ('episode')) 
   AND (rt.role IN ('actor', 
                    'director', 
                    'producer')) 
   AND (n.gender IN ('f', 
                     'm')) 
   AND (n.name_pcode_cf IN ('A4361', 
                            'A5362', 
                            'B6261', 
                            'R363', 
                            'S4153')) 
   AND (t.production_year <= 1990) 
   AND (t.production_year >= 1950) 
   AND (cn.name IN ('Columbia Broadcasting System (CBS)')) 
   AND (ct.kind IN ('distributors')) 
;