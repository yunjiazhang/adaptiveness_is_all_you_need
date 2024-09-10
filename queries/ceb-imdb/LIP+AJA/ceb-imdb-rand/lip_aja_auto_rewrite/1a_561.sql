SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 3) AND (mi1.info = ANY ('{Action,Animation,Crime,Drama,Fantasy,Game-Show,History,Mystery,Romance,Short,Thriller,Western}'::text[])));


/*+
NestLoop(it2 it1 mi2 t kt mi1 ci rt n)
NestLoop(it1 mi2 t kt mi1 ci rt n)
NestLoop(mi2 t kt mi1 ci rt n)
HashJoin(mi2 t kt mi1 ci rt)
NestLoop(mi2 t kt mi1 ci)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
HashJoin(t kt)
IndexScan(mi1)
IndexScan(ci)
SeqScan(it2)
SeqScan(it1)
SeqScan(mi2)
IndexScan(n)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading((it2 (it1 (((((mi2 (t kt)) mi1) ci) rt) n))))
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
 AND (it1.id in ('3')) 
 AND (it2.id in ('2')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Action','Animation','Crime','Drama','Fantasy','Game-Show','History','Mystery','Romance','Short','Thriller','Western')) 
 AND (mi2.info IN ('Black AND White','Color')) 
 AND (kt.kind in ('movie','tv series')) 
 AND (rt.role in ('editor')) 
 AND (n.gender IN ('f','m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
  
;