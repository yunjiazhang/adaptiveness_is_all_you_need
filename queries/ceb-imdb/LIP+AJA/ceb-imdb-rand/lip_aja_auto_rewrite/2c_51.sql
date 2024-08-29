SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{LAB:DeLuxe,MET:,"OFM:35 mm",OFM:Video,"RAT:1.33 : 1","RAT:2.35 : 1"}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 8) AND (mi1.info = ANY ('{Albania,Czechoslovakia,Egypt,Hungary,Italy,Japan,Mexico,Philippines,Sweden,Switzerland}'::text[]))) AND ((mi1.info_type_id = 8) AND (mi1.info = ANY ('{Albania,Czechoslovakia,Egypt,Hungary,Italy,Japan,Mexico,Philippines,Sweden,Switzerland}'::text[])));


/*+
NestLoop(t kt mi2 ci rt mi1 it1 it2 n)
NestLoop(t kt mi2 ci rt mi1 it1 it2)
NestLoop(t kt mi2 ci rt mi1 it1)
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
 AND (it1.id in ('8')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Albania','Czechoslovakia','Egypt','Hungary','Italy','Japan','Mexico','Philippines','Sweden','Switzerland')) 
 AND (mi2.info IN ('LAB:DeLuxe','MET:','OFM:35 mm','OFM:Video','RAT:1.33 : 1','RAT:2.35 : 1')) 
 AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('composer','director','producer')) 
 AND (n.gender IN ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.104)','Androcles AND the Lion','Annie Get Your Gun','Chûkon giretsu - Jitsuroku Chûshingura','Devils Island','Is There Sex After Death?','Monte Carlo','Mr. District Attorney','Sea Devils','Survival','The French Line','The Wrong Man','Treasure Hunt','Winged Victory')) 
  
;