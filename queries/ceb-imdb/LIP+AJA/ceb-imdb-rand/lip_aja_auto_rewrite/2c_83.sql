SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 4) AND (mi2.info = ANY ('{Arabic,Danish,Dutch,English,French,Hindi,Hungarian,Polish}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"70 mm 6-Track",DTS,Datasat,"Dolby Digital EX","Dolby SR",Dolby,Stereo,"Ultra Stereo"}'::text[]))) AND ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{"70 mm 6-Track",DTS,Datasat,"Dolby Digital EX","Dolby SR",Dolby,Stereo,"Ultra Stereo"}'::text[])));


/*+
NestLoop(t kt mi2 ci rt mi1 it1 it2 n)
HashJoin(t kt mi2 ci rt mi1 it1 it2)
NestLoop(t kt mi2 ci rt mi1 it1)
NestLoop(t kt mi2 ci rt mi1)
HashJoin(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('4')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('70 mm 6-Track','DTS','Datasat','Dolby Digital EX','Dolby SR','Dolby','Stereo','Ultra Stereo')) 
 AND (mi2.info IN ('Arabic','Danish','Dutch','English','French','Hindi','Hungarian','Polish')) 
 AND (kt.kind in ('episode','movie','tv movie','video game')) 
 AND (rt.role in ('costume designer')) 
 AND (n.gender IN ('f') OR n.gender IS NULL) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (t.title in ('(#1.549)','(#1.5652)','(#26.9)','(1998-12-10)','(1999-09-23)','(2006-02-15)','(2009-03-08)','At Sea','Children of God','Coulda, Woulda, Shoulda','Goliath','La noche del fuego','Leading Ladies','Murder in the First','Rape','The Sisterhood of the Traveling Pants 2','The Wicked')) 
  
;