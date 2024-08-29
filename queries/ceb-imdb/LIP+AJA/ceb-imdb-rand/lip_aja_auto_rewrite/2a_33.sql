SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info = ANY ('{English,Spanish}'::text[])) AND (mi1.info_type_id = 4));


/*+
NestLoop(mi2 t kt mi1 it1 it2 mk ci rt n k)
NestLoop(mi2 t kt mi1 it1 it2 mk ci rt n)
HashJoin(mi2 t kt mi1 it1 it2 mk ci rt)
NestLoop(mi2 t kt mi1 it1 it2 mk ci)
NestLoop(mi2 t kt mi1 it1 it2 mk)
HashJoin(mi2 t kt mi1 it1 it2)
HashJoin(mi2 t kt mi1 it1)
NestLoop(mi2 t kt mi1)
HashJoin(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(mk)
IndexScan(ci)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
SeqScan(rt)
Leading(((((((((((mi2 t) kt) mi1) it1) it2) mk) ci) rt) n) k))
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
name as n,
movie_keyword as mk,
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
 AND (it2.id in ('18')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('English','Spanish')) 
 AND (mi2.info in ('Buenos Aires, Federal District, Argentina','CBS Studio 50, New York City, New York, USA','CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Los Angeles, California, USA','Mexico City, Distrito Federal, Mexico','Pinewood Studios, Iver Heath, Buckinghamshire, England, UK','Stage 3, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA')) 
 AND (kt.kind in ('episode','movie','tv movie')) 
 AND (rt.role in ('producer')) 
 AND (n.gender in ('f','m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;