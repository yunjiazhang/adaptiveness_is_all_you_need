SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{Mono,Stereo}'::text[])) AND (mi1.info_type_id = 6)) AND ((mi1.info = ANY ('{Mono,Stereo}'::text[])) AND (mi1.info_type_id = 6));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'f'::text) AND ((n.surname_pcode)::text = ANY ('{B2,B4,B6,B63,C2,C5,G6,J525,L,M62,P62,R3,S23}'::text[])));


/*+
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk k)
NestLoop(cn mc ct t kt ci mi1 it1 rt n mk)
NestLoop(cn mc ct t kt ci mi1 it1 rt n)
HashJoin(cn mc ct t kt ci mi1 it1 rt)
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
   AND (it1.id IN ('6')) 
   AND (mi1.info IN ('Mono', 
                     'Stereo')) 
   AND (kt.kind IN ('episode')) 
   AND (rt.role IN ('actress')) 
   AND (n.gender IN ('f')) 
   AND (n.surname_pcode IN ('B2', 
                            'B4', 
                            'B6', 
                            'B63', 
                            'C2', 
                            'C5', 
                            'G6', 
                            'J525', 
                            'L', 
                            'M62', 
                            'P62', 
                            'R3', 
                            'S23')) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1925) 
   AND (cn.name IN ('American Broadcasting Company (ABC)', 
                    'Columbia Broadcasting System (CBS)', 
                    'National Broadcasting Company (NBC)')) 
   AND (ct.kind IN ('distributors')) 
;