SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 6) AND (mi2.info = ANY ('{"4-Track Stereo","70 mm 6-Track",Dolby,Mono,Silent,Stereo}'::text[])));
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
 AND (it2.id in ('6')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Black AND White','Color')) 
 AND (mi2.info IN ('4-Track Stereo','70 mm 6-Track','Dolby','Mono','Silent','Stereo')) 
 AND (kt.kind in ('episode','movie','tv series','video game','video movie')) 
 AND (rt.role in ('composer','costume designer','director','miscellaneous crew')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (t.title in ('(#1.17)','(#1.294)','(#1.342)','(#1.404)','(#1.416)','(#1.535)','(#1.619)','(#1.648)','(#1.840)','(#1.898)','(#10.2)','(#3.34)','A Touch of the Sun','Ace in the Hole','Act of Vengeance','And Baby Makes Two','As You Like It','Belinda','Concealed Enemies, Part I: Suspicion','Crossroads','Dead Mans Shoes','Do It Yourself','Family Reunion','First Date','Ghost in the Machine','Haunted House','Hero','Hotel Polan und seine Gäste','Karate','King of the Gypsies','La gran familia','Limbo','Marina','Night of 100 Stars III','No Way Out','Of Human Bondage','Othello','Retribution','Shadow Play','Ten Little Indians','The Boarder','The Circus','The Hound of the Baskervilles','The Moonlighter','The Silver Chalice','The Thoroughbred','The Unholy','Washington Redskins vs. New York Giants')) 
  
;