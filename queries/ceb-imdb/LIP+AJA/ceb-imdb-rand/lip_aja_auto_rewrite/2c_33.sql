SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 8) AND (mi1.info = ANY ('{Belgium,Georgia,India,Switzerland,UK,Venezuela}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi2.movie_id)), sum(pg_lip_bloom_add(2, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi2.info_type_id = 2)) AND ((mi2.info = ANY ('{"Black AND White",Color}'::text[])) AND (mi2.info_type_id = 2));


/*+
NestLoop(t kt mi1 it1 mi2 it2 ci rt n)
NestLoop(t kt mi1 it1 mi2 it2 ci rt)
NestLoop(t kt mi1 it1 mi2 it2 ci)
HashJoin(t kt mi1 it1 mi2 it2)
NestLoop(t kt mi1 it1 mi2)
HashJoin(t kt mi1 it1)
NestLoop(t kt mi1)
HashJoin(t kt)
IndexScan(mi1)
IndexScan(mi2)
IndexScan(ci)
IndexScan(rt)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
SeqScan(t)
Leading(((((((((t kt) mi1) it1) mi2) it2) ci) rt) n))
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
(
    SELECT * FROM movie_info as mi1
    WHERE 
pg_lip_bloom_probe(2, mi1.movie_id) 
) AS mi1,
movie_info as mi2,
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
 AND (it1.id in ('8')) 
 AND (it2.id in ('2')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Belgium','Georgia','India','Switzerland','UK','Venezuela')) 
 AND (mi2.info IN ('Black AND White','Color')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('cinematographer','editor','guest','producer','production designer')) 
 AND (n.gender IN ('f','m')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (t.title in ('(#1.14)','(#1.187)','(#1.326)','(#1.42)','(#1.486)','(#1.53)','(#11.5)','(#2.29)','(#3.22)','(#7.12)','(#9.24)','Abduction','Act of Vengeance','Death Sentence','Dyesebel','Fighting Back','For Richer, for Poorer','Home for Christmas','Hôtel Terminus','Its All Happening','Live AND Let Die','Olho por Olho','Playing with Fire','Salsa','Shall We Dance?','Suburbia','The 43rd Annual Golden Globe Awards','The Awakening','The Final Test','The Great Escape','The Guiding Light','The Last Emperor','The Son Also Rises','Transitions','Werther','Whats Up, Doc?','Where Theres a Will...')) 
  
;