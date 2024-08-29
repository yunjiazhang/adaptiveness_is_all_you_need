SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 4) AND (mi2.info = ANY ('{Albanian,Bengali,Bulgarian,Cantonese,Filipino,Georgian,Hebrew,Hungarian,Japanese,Portuguese,Russian,Slovak,Thai}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2)) AND ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2));


/*+
NestLoop(t kt mi2 mi1 it1 it2 ci rt n)
NestLoop(t kt mi2 mi1 it1 it2 ci rt)
NestLoop(t kt mi2 mi1 it1 it2 ci)
HashJoin(t kt mi2 mi1 it1 it2)
HashJoin(t kt mi2 mi1 it1)
NestLoop(t kt mi2 mi1)
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
Leading(((((((((t kt) mi2) mi1) it1) it2) ci) rt) n))
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
(
    SELECT * FROM movie_info as mi2
    WHERE 
pg_lip_bloom_probe(2, mi2.movie_id) 
) AS mi2,
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
 AND (it1.id in ('2')) 
 AND (it2.id in ('4')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Black AND White','Color')) 
 AND (mi2.info IN ('Albanian','Bengali','Bulgarian','Cantonese','Filipino','Georgian','Hebrew','Hungarian','Japanese','Portuguese','Russian','Slovak','Thai')) 
 AND (kt.kind in ('episode','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('cinematographer','guest','production designer','writer')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.114)','(#1.3445)','(#2.62)','(#6.96)','(2009-03-06)','(2009-08-31)','(2011-12-11)','Adjust Your Tracking','Am Ende des Tages','Bad Behaviour','Blast','Bless the Child','Day 100: Finale','Fait Accompli','Fear AND Loathing in Las Vegas','French Kiss','Front Mission 4','Gate Keepers','Gaviotas blindadas 3','Happy on the Ground: 8 Days at GRAMMY Camp®','Introduction','Issues','Joyride','La traición','Namets!','No Contest','Oil & Water','Rearview','Ridicule','Suomen Robinson','The Believers','The Haunted Piano','The Knockout','Ursula')) 
  
;