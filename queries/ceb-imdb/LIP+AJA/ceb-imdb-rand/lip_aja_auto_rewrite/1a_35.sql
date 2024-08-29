SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Austria,Brazil,China,Denmark,Iceland,Ireland,Philippines,Poland,Portugal,Romania,Spain,Turkey,"West Germany"}'::text[])));


/*+
NestLoop(mi1 t kt mi2 ci rt it1 it2 n)
HashJoin(mi1 t kt mi2 ci rt it1 it2)
HashJoin(mi1 t kt mi2 ci rt it1)
NestLoop(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((mi1 t) kt) mi2) ci) rt) it1) it2) n))
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
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('5')) 
 AND (it2.id in ('8')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Germany:12','Germany:16','Hungary:16','India:A','Malaysia:U','New Zealand:PG','Portugal:M/6','Spain:X','Sweden:11','USA:TV-Y7','USA:Unrated')) 
 AND (mi2.info IN ('Austria','Brazil','China','Denmark','Iceland','Ireland','Philippines','Poland','Portugal','Romania','Spain','Turkey','West Germany')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('production designer')) 
 AND (n.gender IN ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
  
;