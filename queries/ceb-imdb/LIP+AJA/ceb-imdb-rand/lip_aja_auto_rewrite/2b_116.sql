SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 1) AND (mi1.info = ANY ('{90,Argentina:30,Argentina:60}'::text[]))) AND ((mi1.info_type_id = 1) AND (mi1.info = ANY ('{90,Argentina:30,Argentina:60}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Argentina:16,Argentina:Atp,USA:R}'::text[]))) AND ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Argentina:16,Argentina:Atp,USA:R}'::text[])));


/*+
NestLoop(k mk t kt mi1 it1 ci mi2 it2 rt n)
NestLoop(k mk t kt mi1 it1 ci mi2 it2 rt)
HashJoin(k mk t kt mi1 it1 ci mi2 it2)
NestLoop(k mk t kt mi1 it1 ci mi2)
NestLoop(k mk t kt mi1 it1 ci)
HashJoin(k mk t kt mi1 it1)
NestLoop(k mk t kt mi1)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mi1)
IndexScan(mi2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(k)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((((k mk) t) kt) mi1) it1) ci) mi2) it2) rt) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id)  AND pg_lip_bloom_probe(2, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(3, ci.movie_id) 
) AS ci,
role_type as rt,
name as n,
(
    SELECT * FROM movie_keyword as mk
    WHERE 
pg_lip_bloom_probe(0, mk.movie_id) 
) AS mk,
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
 AND (it1.id in ('1')) 
 AND (it2.id in ('5')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('90','Argentina:30','Argentina:60')) 
 AND (mi2.info in ('Argentina:16','Argentina:Atp','USA:R')) 
 AND (kt.kind in ('episode','movie','video movie')) 
 AND (rt.role in ('writer')) 
 AND (n.gender in ('m')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (k.keyword IN ('based-on-play','blood','dancing','lesbian-sex','male-frontal-nudity','marriage','mother-son-relationship','new-york-city')) 
  
;