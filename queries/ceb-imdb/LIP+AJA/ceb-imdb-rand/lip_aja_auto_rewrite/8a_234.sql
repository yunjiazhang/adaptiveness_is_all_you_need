SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 2) AND (mi1.info = 'Color'::text)) AND ((mi1.info_type_id = 2) AND (mi1.info = 'Color'::text));


/*+
HashJoin(cn mc ct t kt mi1 mk ci rt it1 n k)
HashJoin(cn mc ct t kt mi1 mk ci rt it1 n)
HashJoin(cn mc ct t kt mi1 mk ci rt it1)
HashJoin(cn mc ct t kt mi1 mk ci rt)
NestLoop(cn mc ct t kt mi1 mk ci)
NestLoop(cn mc ct t kt mi1 mk)
NestLoop(cn mc ct t kt mi1)
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
Leading((((((((((((cn mc) ct) t) kt) mi1) mk) ci) rt) it1) n) k))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
(
    SELECT * FROM movie_companies as mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
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
 AND (it1.id IN ('2')) 
 AND (mi1.info in ('Color')) 
 AND (kt.kind in ('movie','tv movie')) 
 AND (rt.role in ('cinematographer','composer','costume designer','director','miscellaneous crew','writer')) 
 AND (n.gender IS NULL) 
 AND (n.surname_pcode in ('B65','J52','J525','R2','S53') OR n.surname_pcode IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (cn.name in ('Columbia Broadcasting System (CBS)','Metro-Goldwyn-Mayer (MGM)','Paramount Pictures','Pathé Frères','Universal Pictures','Warner Home Video')) 
 AND (ct.kind in ('distributors','production companies')) 
  
;