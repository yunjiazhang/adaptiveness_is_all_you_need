SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{30,60}'::text[])) AND (mi2.info_type_id = 1)) AND ((mi2.info = ANY ('{30,60}'::text[])) AND (mi2.info_type_id = 1));
SELECT sum(pg_lip_bloom_add(2, mi1.movie_id)), sum(pg_lip_bloom_add(3, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","New York City, New York, USA","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Revue Studios, Hollywood, Los Angeles, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","New York City, New York, USA","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Revue Studios, Hollywood, Los Angeles, California, USA"}'::text[])));


/*+
NestLoop(k mk t kt mi2 ci mi1 it1 it2 rt n)
NestLoop(k mk t kt mi2 ci mi1 it1 it2 rt)
HashJoin(k mk t kt mi2 ci mi1 it1 it2)
HashJoin(k mk t kt mi2 ci mi1 it1)
NestLoop(k mk t kt mi2 ci mi1)
NestLoop(k mk t kt mi2 ci)
NestLoop(k mk t kt mi2)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(k)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((((k mk) t) kt) mi2) ci) mi1) it1) it2) rt) n))
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
 AND (it1.id in ('18')) 
 AND (it2.id in ('1')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','New York City, New York, USA','Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA','Revue Studios, Hollywood, Los Angeles, California, USA')) 
 AND (mi2.info in ('30','60')) 
 AND (kt.kind in ('tv series','video game','video movie')) 
 AND (rt.role in ('cinematographer','costume designer')) 
 AND (n.gender in ('f','m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (k.keyword IN ('dancing','male-frontal-nudity','mother-son-relationship','murder','non-fiction','police')) 
  
;