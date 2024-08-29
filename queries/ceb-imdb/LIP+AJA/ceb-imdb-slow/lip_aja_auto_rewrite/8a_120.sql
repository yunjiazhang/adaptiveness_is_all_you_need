SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adventure,Animation,Comedy,Crime,Documentary,Drama,Family,Romance,Short,Thriller}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adventure,Animation,Comedy,Crime,Documentary,Drama,Family,Romance,Short,Thriller}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = ANY ('{f,m}'::text[])) AND ((n.name_pcode_cf)::text = ANY ('{A5362,B4525,B6261,D1232,H4236,J5252,P5235,P6252,R1632,S3152}'::text[])));


/*+
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n k)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt n)
HashJoin(cn mc ct t kt mk mi1 it1 ci rt)
HashJoin(cn mc ct t kt mk mi1 it1 ci)
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
pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
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
                     'Animation', 
                     'Comedy', 
                     'Crime', 
                     'Documentary', 
                     'Drama', 
                     'Family', 
                     'Romance', 
                     'Short', 
                     'Thriller')) 
   AND (kt.kind IN ('movie')) 
   AND (rt.role IN ('actor', 
                    'actress', 
                    'producer')) 
   AND (n.gender IN ('f', 
                     'm')) 
   AND (n.name_pcode_cf IN ('A5362', 
                            'B4525', 
                            'B6261', 
                            'D1232', 
                            'H4236', 
                            'J5252', 
                            'P5235', 
                            'P6252', 
                            'R1632', 
                            'S3152')) 
   AND (t.production_year <= 1975) 
   AND (t.production_year >= 1875) 
   AND (cn.name IN ('Columbia Broadcasting System (CBS)', 
                    'Metro-Goldwyn-Mayer (MGM)', 
                    'Paramount Pictures', 
                    'Pathé Frères', 
                    'Universal Pictures', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;