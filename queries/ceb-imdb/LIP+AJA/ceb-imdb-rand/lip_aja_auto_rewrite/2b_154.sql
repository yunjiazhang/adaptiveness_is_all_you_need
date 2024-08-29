SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 4) AND (mi1.info = ANY ('{English,German,Greek,Hindi,Japanese,Korean,Spanish,Swedish}'::text[]))) AND ((mi1.info_type_id = 4) AND (mi1.info = ANY ('{English,German,Greek,Hindi,Japanese,Korean,Spanish,Swedish}'::text[])));
SELECT sum(pg_lip_bloom_add(2, mi2.movie_id)), sum(pg_lip_bloom_add(3, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Animation,Comedy,Documentary,Drama,Musical,Mystery,Sci-Fi,Short,Thriller}'::text[]))) AND ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Animation,Comedy,Documentary,Drama,Musical,Mystery,Sci-Fi,Short,Thriller}'::text[])));


/*+
NestLoop(k mk t kt mi1 mi2 ci rt it1 it2 n)
HashJoin(k mk t kt mi1 mi2 ci rt it1 it2)
HashJoin(k mk t kt mi1 mi2 ci rt it1)
HashJoin(k mk t kt mi1 mi2 ci rt)
NestLoop(k mk t kt mi1 mi2 ci)
NestLoop(k mk t kt mi1 mi2)
NestLoop(k mk t kt mi1)
HashJoin(k mk t kt)
NestLoop(k mk t)
NestLoop(k mk)
IndexScan(mi1)
IndexScan(mi2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(k)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
SeqScan(kt)
Leading(((((((((((k mk) t) kt) mi1) mi2) ci) rt) it1) it2) n))
*/
 SELECT COUNT(*) 
FROM 
(
    SELECT * FROM title as t
    WHERE 
pg_lip_bloom_probe(1, t.id)  AND pg_lip_bloom_probe(3, t.id) 
) AS t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
(
    SELECT * FROM movie_keyword as mk
    WHERE 
pg_lip_bloom_probe(0, mk.movie_id)  AND pg_lip_bloom_probe(2, mk.movie_id) 
) AS mk,
keyword as k
WHERE 
 
 t.id = ci.movie_id 
 AND t.id = mi1.movie_id 
 AND t.id = mi2.movie_id 
 AND t.id = mk.movie_id 
 AND k.id = mk.keyword_id 
 AND mi1.movie_id = mi2.movie_id 
 AND mi1.info_type_id = it1.id 
 AND mi2.info_type_id = it2.id 
 AND (it1.id in ('4')) 
 AND (it2.id in ('3')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('English','German','Greek','Hindi','Japanese','Korean','Spanish','Swedish')) 
 AND (mi2.info in ('Animation','Comedy','Documentary','Drama','Musical','Mystery','Sci-Fi','Short','Thriller')) 
 AND (kt.kind in ('episode','movie','video movie')) 
 AND (rt.role in ('cinematographer')) 
 AND (n.gender in ('f')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1990) 
 AND (k.keyword IN ('anal-sex','based-on-play','cigarette-smoking','father-son-relationship','female-frontal-nudity','fight','flashback','friendship','hardcore','love','male-frontal-nudity','mother-son-relationship','new-york-city','nudity','party','police','revenge','sex','singer','singing','surrealism')) 
  
;