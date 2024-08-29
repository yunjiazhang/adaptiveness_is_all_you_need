SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"CAM:Panaflex Camera AND Lenses by Panavision","LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",LAB:DeLuxe,"LAB:Film Center, Mumbai, India","LAB:Movielab, USA","LAB:Rank Film Laboratories, Denham, UK","OFM:16 mm",PCS:Panavision,PCS:Tohoscope,"PFM:16 mm",PFM:Video,"RAT:1.33 : 1","RAT:1.78 : 1",RAT:4:3}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adult,Fantasy,Game-Show,Horror,Musical}'::text[]))) AND ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Adult,Fantasy,Game-Show,Horror,Musical}'::text[])));


/*+
NestLoop(t kt mi2 ci rt mi1 it1 it2 n)
HashJoin(t kt mi2 ci rt mi1 it1 it2)
HashJoin(t kt mi2 ci rt mi1 it1)
NestLoop(t kt mi2 ci rt mi1)
NestLoop(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
SeqScan(t)
Leading(((((((((t kt) mi2) ci) rt) mi1) it1) it2) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id)  AND pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(2, ci.movie_id) 
) AS ci,
role_type as rt,
name as n
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('3')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Adult','Fantasy','Game-Show','Horror','Musical')) 
 AND (mi2.info IN ('CAM:Panaflex Camera AND Lenses by Panavision','LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','LAB:DeLuxe','LAB:Film Center, Mumbai, India','LAB:Movielab, USA','LAB:Rank Film Laboratories, Denham, UK','OFM:16 mm','PCS:Panavision','PCS:Tohoscope','PFM:16 mm','PFM:Video','RAT:1.33 : 1','RAT:1.78 : 1','RAT:4:3')) 
 AND (kt.kind in ('movie','tv movie','video game','video movie')) 
 AND (rt.role in ('miscellaneous crew')) 
 AND (n.gender IN ('f','m') OR n.gender IS NULL) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (t.title in ('(#1.301)','(#1.51)','(#3.16)','(#8.22)','A Change of Heart','Arrival','Atlanta Falcons vs. Philadelphia Eagles','Big Business','Cant Stop the Music','Fun House','La traviata','Life of Brian','Please Believe Me','The 34th Annual Emmy Awards','The Appointment','The Bachelor Party','The Big Parade of Comedy','The Love God?','The Outsiders','The Ratings Game','The Shower','To Catch a Thief','Witch Hunt')) 
  
;