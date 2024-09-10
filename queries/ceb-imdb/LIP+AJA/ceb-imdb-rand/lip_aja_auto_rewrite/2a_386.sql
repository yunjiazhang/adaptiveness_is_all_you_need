SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Czechoslovakia,France,Germany,Italy,Philippines,"West Germany"}'::text[])));


/*+
NestLoop(mi1 t kt mi2 it1 it2 ci rt n mk k)
NestLoop(mi1 t kt mi2 it1 it2 ci rt n mk)
NestLoop(mi1 t kt mi2 it1 it2 ci rt n)
HashJoin(mi1 t kt mi2 it1 it2 ci rt)
NestLoop(mi1 t kt mi2 it1 it2 ci)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
IndexScan(mk)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading(((((((((((mi1 t) kt) mi2) it1) it2) ci) rt) n) mk) k))
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
 AND (it1.id in ('4')) 
 AND (it2.id in ('8')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Czech','French','German','Italian','Tagalog')) 
 AND (mi2.info in ('Czechoslovakia','France','Germany','Italy','Philippines','West Germany')) 
 AND (kt.kind in ('movie','tv movie')) 
 AND (rt.role in ('editor','production designer')) 
 AND (n.gender in ('f')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
  
;