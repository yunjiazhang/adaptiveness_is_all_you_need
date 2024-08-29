SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Crime,Drama,Romance,Short}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Crime,Drama,Romance,Short}'::text[])));


/*+
HashJoin(cn mc ct t kt ci mi1 it1 rt n mk k)
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
pg_lip_bloom_probe(1, ci.movie_id) 
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
   AND (it1.id IN ('3')) 
   AND (mi1.info IN ('Action', 
                     'Crime', 
                     'Drama', 
                     'Romance', 
                     'Short')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('actor', 
                    'costume designer', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('m') 
        OR n.gender IS NULL) 
   AND (n.surname_pcode IN ('B62', 
                            'C2', 
                            'H2', 
                            'J525', 
                            'M46', 
                            'M6', 
                            'M62', 
                            'S5', 
                            'S53', 
                            'W3') 
        OR n.surname_pcode IS NULL) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1875) 
   AND (cn.name IN ('Universal Pictures', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors')) 
;