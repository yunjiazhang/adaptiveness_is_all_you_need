SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 6) AND (mi2.info = ANY ('{"4-Track Stereo",Mono,Silent,Stereo}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 4) AND (mi1.info = ANY ('{Cantonese,Dutch,Filipino,French,Greek,Hindi,Japanese,None,Polish}'::text[]))) AND ((mi1.info_type_id = 4) AND (mi1.info = ANY ('{Cantonese,Dutch,Filipino,French,Greek,Hindi,Japanese,None,Polish}'::text[])));


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
 AND (it1.id in ('4')) 
 AND (it2.id in ('6')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Cantonese','Dutch','Filipino','French','Greek','Hindi','Japanese','None','Polish')) 
 AND (mi2.info IN ('4-Track Stereo','Mono','Silent','Stereo')) 
 AND (kt.kind in ('movie','tv movie','video game','video movie')) 
 AND (rt.role in ('actor','cinematographer','composer','director')) 
 AND (n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (t.title in ('(#1.114)','(#1.83)','(#1.87)','(#2.41)','Around the World in Eighty Days','Bells Are Ringing','Day of Reckoning','Der Bettelstudent','Destiny','Dirty Harry','East Side, West Side','Giuseppe Verdi','Haunted House','Holnap lesz fácán','Island in the Sky','Its a Great Life','Jesse James','Lenny','Meet Me in Las Vegas','Pat AND Mike','Sea Devils','Star Spangled Rhythm','Teresa','The Crowd Roars','The Engagement Ring','The Judge','The Kid FROM Texas','The Losers','The Morning After','The Oath','The Party','The Professionals','The Star','The Westerner','The Women','Time Out of Mind','Titanic','Too Hot to Handle','Whistling in the Dark')) 
  
;