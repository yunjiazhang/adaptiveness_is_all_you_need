SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA","LAB:Technicolor, USA",PCS:CinemaScope,PCS:Spherical,"RAT:1.66 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2)) AND ((mi1.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi1.info_type_id = 2));


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
 AND (it1.id in ('2')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Black AND White','Color')) 
 AND (mi2.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','LAB:Technicolor, USA','PCS:CinemaScope','PCS:Spherical','RAT:1.66 : 1')) 
 AND (kt.kind in ('episode','movie','tv series','video game','video movie')) 
 AND (rt.role in ('costume designer')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.108)','(#1.36)','(#3.43)','(#3.52)','(#5.2)','(#6.10)','(#6.9)','Big City','Crime Wave','Holnap lesz fácán','Jesse James','Kid Galahad','Out of the Blue','Ruggles of Red Gap','The Accident','The Adventures of Huckleberry Finn','The Arrangement','The Birthday','The Bribe','The Gold Rush','The Last Man','The Masked Marvel','The Outcast','The Outsider','Welcome Stranger','Who Done It?')) 
  
;