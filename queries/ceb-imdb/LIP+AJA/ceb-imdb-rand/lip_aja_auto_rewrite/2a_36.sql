SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 18) AND (mi2.info = ANY ('{"Buenos Aires, Federal District, Argentina","CBS Studio 50, New York City, New York, USA","Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA",Mexico,"New York City, New York, USA","Paris, France","Pinewood Studios, Iver Heath, Buckinghamshire, England, UK","Samuel Goldwyn Studios - 7200 Santa Monica Boulevard, West Hollywood, California, USA","Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA"}'::text[])));


/*+
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n k)
NestLoop(mi1 t kt mi2 it1 it2 mk ci rt n)
HashJoin(mi1 t kt mi2 it1 it2 mk ci rt)
NestLoop(mi1 t kt mi2 it1 it2 mk ci)
NestLoop(mi1 t kt mi2 it1 it2 mk)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
HashJoin(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
SeqScan(kt)
Leading(((((((((((mi1 t) kt) mi2) it1) it2) mk) ci) rt) n) k))
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('18')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('Mono','Silent')) 
 AND (mi2.info in ('Buenos Aires, Federal District, Argentina','CBS Studio 50, New York City, New York, USA','Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA','Mexico','New York City, New York, USA','Paris, France','Pinewood Studios, Iver Heath, Buckinghamshire, England, UK','Samuel Goldwyn Studios - 7200 Santa Monica Boulevard, West Hollywood, California, USA','Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA')) 
 AND (kt.kind in ('episode','movie','tv movie')) 
 AND (rt.role in ('cinematographer')) 
 AND (n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
  
;