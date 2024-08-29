SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{Mono,Stereo}'::text[])) AND (mi1.info_type_id = 6)) AND ((mi1.info = ANY ('{Mono,Stereo}'::text[])) AND (mi1.info_type_id = 6));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Australia:M,Iceland:12,UK:15,UK:X}'::text[]))) AND ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Australia:M,Iceland:12,UK:15,UK:X}'::text[])));


/*+
NestLoop(k mk t kt mi1 it1 mi2 it2 ci rt n)
NestLoop(k mk t kt mi1 it1 mi2 it2 ci rt)
NestLoop(k mk t kt mi1 it1 mi2 it2 ci)
HashJoin(k mk t kt mi1 it1 mi2 it2)
NestLoop(k mk t kt mi1 it1 mi2)
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
Leading(((((((((((k mk) t) kt) mi1) it1) mi2) it2) ci) rt) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id)  AND pg_lip_bloom_probe(3, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
(
    SELECT * FROM movie_keyword as mk
    WHERE 
pg_lip_bloom_probe(0, mk.movie_id)  AND pg_lip_bloom_probe(2, mk.movie_id) 
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('5')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Mono','Stereo')) 
 AND (mi2.info in ('Australia:M','Iceland:12','UK:15','UK:X')) 
 AND (kt.kind in ('episode','movie','video movie')) 
 AND (rt.role in ('editor')) 
 AND (n.gender in ('m')) 
 AND (t.production_year <= 2010) 
 AND (t.production_year >= 1950) 
 AND (k.keyword IN ('assassination-of-robert-f.-kennedy','book-binding','crushed-foot','czar-ivan-iv-of-russia','doctor-faustef','dog-on-motorcycle','driver-falling-asleep','english-restoration','herb-shop','iron-ore','jinniku','mother-drowning-her-children','pet-deer','pioneer-camp','pro-wrestling','reference-to-irene-castle','shao-fang-house','sickle-cell-anemia','throwing-water-onto-ones-face','unknown-creature','wetsuit','white-sand-beach','wrestling-team')) 
  
;