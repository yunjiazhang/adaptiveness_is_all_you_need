SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 4) AND (mi1.info = ANY ('{English,German,Hindi,Italian,Japanese,Latin,Polish,Portuguese,Spanish}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi2.movie_id)), sum(pg_lip_bloom_add(2, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info = ANY ('{"Last show of the series.","One of over 700 Paramount Productions, filmed between 1929 AND 1949, which were sold to MCA/Universal in 1958 for television distribution, AND have been owned AND controlled by Universal ever since."}'::text[])) AND (mi2.info_type_id = 17)) AND ((mi2.info = ANY ('{"Last show of the series.","One of over 700 Paramount Productions, filmed between 1929 AND 1949, which were sold to MCA/Universal in 1958 for television distribution, AND have been owned AND controlled by Universal ever since."}'::text[])) AND (mi2.info_type_id = 17));


/*+
NestLoop(t kt mi1 it1 ci rt mi2 it2 n)
NestLoop(t kt mi1 it1 ci rt mi2 it2)
NestLoop(t kt mi1 it1 ci rt mi2)
NestLoop(t kt mi1 it1 ci rt)
NestLoop(t kt mi1 it1 ci)
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
Leading(((((((((t kt) mi1) it1) ci) rt) mi2) it2) n))
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
 AND (it2.id in ('17')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('English','German','Hindi','Italian','Japanese','Latin','Polish','Portuguese','Spanish')) 
 AND (mi2.info IN ('Last show of the series.','One of over 700 Paramount Productions, filmed between 1929 AND 1949, which were sold to MCA/Universal in 1958 for television distribution, AND have been owned AND controlled by Universal ever since.')) 
 AND (kt.kind in ('movie','tv series','video game','video movie')) 
 AND (rt.role in ('actress','composer','costume designer','production designer')) 
 AND (n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.47)','(#4.26)','Cinderella','Fools Gold','Going Home','Ill Fix It','Law AND Disorder','Shakedown','The Box','The Gangs All Here','The Scarlet Pimpernel','The Shepherd of the Hills','You AND Me')) 
  
;