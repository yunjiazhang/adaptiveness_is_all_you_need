SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi2.info_type_id = 2));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"4-Track Stereo",Silent,Stereo}'::text[]))) AND ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"4-Track Stereo",Silent,Stereo}'::text[])));


/*+
NestLoop(t kt mi2 ci rt n mi1 it1 it2)
NestLoop(t kt mi2 ci rt n mi1 it1)
NestLoop(t kt mi2 ci rt n mi1)
NestLoop(t kt mi2 ci rt n)
NestLoop(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
SeqScan(t)
Leading(((((((((t kt) mi2) ci) rt) n) mi1) it1) it2))
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('2')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('4-Track Stereo','Silent','Stereo')) 
 AND (mi2.info IN ('Black AND White','Color')) 
 AND (kt.kind in ('movie','tv movie','video game','video movie')) 
 AND (rt.role in ('cinematographer','composer')) 
 AND (n.gender IN ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
 AND (t.title in ('(#3.15)','(#3.35)','(#3.42)','(#7.2)','Artists AND Models','Carrie','Checkmate','Du Barry Was a Lady','Familie Benthin','Giuseppe Verdi','La dolce vita','Lili','Mr. Deeds Goes to Town','Mr. Skeffington','Notorious','Reunion','Runaway','The Bohemian Girl','The Clock','The Gangs All Here','The Heiress','The Set-Up','With a Song in My Heart')) 
  
;