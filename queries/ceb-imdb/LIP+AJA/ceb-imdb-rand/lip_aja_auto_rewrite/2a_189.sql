SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 5) AND (mi1.info = ANY ('{Australia:G,Australia:PG,Belgium:KT,Canada:PG,Finland:K-16,Finland:S,Norway:16,Sweden:Btl,UK:A,UK:PG,USA:Passed,USA:TV-G,"West Germany:12","West Germany:16","West Germany:18"}'::text[])));


/*+
HashJoin(mi2 t kt mi1 it1 it2 mk ci rt n k)
HashJoin(mi2 t kt mi1 it1 it2 mk ci rt n)
HashJoin(mi2 t kt mi1 it1 it2 mk ci rt)
NestLoop(mi2 t kt mi1 it1 it2 mk ci)
NestLoop(mi2 t kt mi1 it1 it2 mk)
HashJoin(mi2 t kt mi1 it1 it2)
HashJoin(mi2 t kt mi1 it1)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
Leading(((((((((((mi2 t) kt) mi1) it1) it2) mk) ci) rt) n) k))
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
cast_info as ci,
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
 AND (it2.id in ('6')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Australia:G','Australia:PG','Belgium:KT','Canada:PG','Finland:K-16','Finland:S','Norway:16','Sweden:Btl','UK:A','UK:PG','USA:Passed','USA:TV-G','West Germany:12','West Germany:16','West Germany:18')) 
 AND (mi2.info in ('Mono')) 
 AND (kt.kind in ('episode','movie','tv movie')) 
 AND (rt.role in ('actor')) 
 AND (n.gender in ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;