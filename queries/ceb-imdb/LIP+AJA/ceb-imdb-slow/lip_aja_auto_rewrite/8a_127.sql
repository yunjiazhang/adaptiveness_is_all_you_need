SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adventure,Fantasy,Music,Musical,Mystery,Sci-Fi,War}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adventure,Fantasy,Music,Musical,Mystery,Sci-Fi,War}'::text[])));


/*+
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n k)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt)
NestLoop(cn mc ct t kt mk mi1 it1 ci)
HashJoin(cn mc ct t kt mk mi1 it1)
HashJoin(cn mc ct t kt mk mi1)
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
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
cast_info AS ci,
role_type AS rt,
name AS n,
(
    SELECT * FROM movie_keyword AS mk
    WHERE 
pg_lip_bloom_probe(1, mk.movie_id) 
) AS mk,
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
   AND (mi1.info IN ('Adventure', 
                     'Fantasy', 
                     'Music', 
                     'Musical', 
                     'Mystery', 
                     'Sci-Fi', 
                     'War')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('actress', 
                    'cinematographer', 
                    'miscellaneous crew')) 
   AND (n.gender IN ('f') 
        OR n.gender IS NULL) 
   AND (n.surname_pcode IN ('L', 
                            'R2', 
                            'S53') 
        OR n.surname_pcode IS NULL) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1875) 
   AND (cn.name IN ('Metro-Goldwyn-Mayer (MGM)', 
                    'Paramount Pictures', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors')) 
;