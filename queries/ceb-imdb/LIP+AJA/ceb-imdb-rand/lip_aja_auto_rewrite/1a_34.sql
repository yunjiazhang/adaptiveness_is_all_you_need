SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Action,Adult,Animation,Biography,Drama,Game-Show,Music,Musical,Mystery,Reality-TV,Sci-Fi,Thriller,War}'::text[])));


/*+
NestLoop(it2 it1 mi1 t kt mi2 ci rt n)
NestLoop(it1 mi1 t kt mi2 ci rt n)
NestLoop(mi1 t kt mi2 ci rt n)
HashJoin(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi1)
IndexScan(t)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
Leading((it2 (it1 ((((((mi1 t) kt) mi2) ci) rt) n))))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(0, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
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
 AND (it1.id in ('5')) 
 AND (it2.id in ('3')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Australia:MA','Belgium:KT','Canada:14','Canada:18','Finland:K-18','Ireland:15A','Netherlands:MG6','Portugal:M/16','Singapore:PG13','South Africa:PG','South Korea:12','Spain:13','UK:AA','UK:E','USA:X')) 
 AND (mi2.info IN ('Action','Adult','Animation','Biography','Drama','Game-Show','Music','Musical','Mystery','Reality-TV','Sci-Fi','Thriller','War')) 
 AND (kt.kind in ('movie','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('costume designer','editor','production designer','writer')) 
 AND (n.gender IN ('f')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1925) 
  
;