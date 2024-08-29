SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = 'USA:Approved'::text)) AND ((mi1.info_type_id = 5) AND (mi1.info = 'USA:Approved'::text));


/*+
NestLoop(mi2 t kt mk ci rt mi1 it1 it2 n k)
NestLoop(mi2 t kt mk ci rt mi1 it1 it2 n)
NestLoop(mi2 t kt mk ci rt mi1 it1 it2)
NestLoop(mi2 t kt mk ci rt mi1 it1)
NestLoop(mi2 t kt mk ci rt mi1)
NestLoop(mi2 t kt mk ci rt)
NestLoop(mi2 t kt mk ci)
NestLoop(mi2 t kt mk)
NestLoop(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(kt)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
Leading(((((((((((mi2 t) kt) mk) ci) rt) mi1) it1) it2) n) k))
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
movie_info as mi2,
info_type as it2,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
) AS ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND t.id = mk.movie_id 
 AND k.id = mk.keyword_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('5')) 
 AND (it2.id in ('18')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('USA:Approved')) 
 AND (mi2.info in ('Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA')) 
 AND (kt.kind in ('tv series','video game','video movie')) 
 AND (rt.role in ('director','producer')) 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;