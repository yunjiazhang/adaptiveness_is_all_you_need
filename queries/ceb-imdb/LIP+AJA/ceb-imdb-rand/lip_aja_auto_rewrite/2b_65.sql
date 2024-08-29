SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"CAM:Canon 7D","CAM:Canon XL-1","CAM:Panasonic AG-DVX100","CAM:Panasonic AG-HVX200","LAB:DeLuxe, Hollywood (CA), USA",OFM:HDCAM,"OFM:Redcode RAW",OFM:Video,"PCS:Betacam SP",PCS:DVCAM,PCS:HDCAM,PCS:Spherical,"RAT:1.66 : 1","RAT:1.78 : 1","RAT:2.35 : 1"}'::text[]))) AND ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"CAM:Canon 7D","CAM:Canon XL-1","CAM:Panasonic AG-DVX100","CAM:Panasonic AG-HVX200","LAB:DeLuxe, Hollywood (CA), USA",OFM:HDCAM,"OFM:Redcode RAW",OFM:Video,"PCS:Betacam SP",PCS:DVCAM,PCS:HDCAM,PCS:Spherical,"RAT:1.66 : 1","RAT:1.78 : 1","RAT:2.35 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi1.movie_id)), sum(pg_lip_bloom_add(3, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2)) AND ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2));


/*+
NestLoop(k mk t kt mi2 mi1 it1 it2 ci rt n)
NestLoop(k mk t kt mi2 mi1 it1 it2 ci rt)
NestLoop(k mk t kt mi2 mi1 it1 it2 ci)
HashJoin(k mk t kt mi2 mi1 it1 it2)
HashJoin(k mk t kt mi2 mi1 it1)
NestLoop(k mk t kt mi2 mi1)
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
Leading(((((((((((k mk) t) kt) mi2) mi1) it1) it2) ci) rt) n))
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
 AND (it1.id in ('2')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Black AND White','Color')) 
 AND (mi2.info in ('CAM:Canon 7D','CAM:Canon XL-1','CAM:Panasonic AG-DVX100','CAM:Panasonic AG-HVX200','LAB:DeLuxe, Hollywood (CA), USA','OFM:HDCAM','OFM:Redcode RAW','OFM:Video','PCS:Betacam SP','PCS:DVCAM','PCS:HDCAM','PCS:Spherical','RAT:1.66 : 1','RAT:1.78 : 1','RAT:2.35 : 1')) 
 AND (kt.kind in ('episode','movie')) 
 AND (rt.role in ('cinematographer','production designer')) 
 AND (n.gender in ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (k.keyword IN ('acting-lesson','agricultural-cooperative','apollo','at-64-uss-navajo-tug','based-on-comic-book','centegenarian','eco','ending-taxation','genome','gyarados','island-city','kansas-state-university','key-maker','lipa','nhs','patiala-india','reference-to-john-wayne','referrence-to-royale-with-cheese','removing-intravenous-line','running-out-of-ammo','seven-point-police-badge','spiraling-eyes','stripping-wallpaper','three-friends')) 
  
;