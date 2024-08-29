SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"Big Ben, Houses of Parliament, Westminster, London, England, UK","CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Santa Clarita, California, USA",Spain,"Stage 1, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA","Stage 5, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA","Stage 8, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","Washington, District of Columbia, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"Big Ben, Houses of Parliament, Westminster, London, England, UK","CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Santa Clarita, California, USA",Spain,"Stage 1, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA","Stage 5, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA","Stage 8, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","Washington, District of Columbia, USA"}'::text[])));


/*+
NestLoop(mi2 t kt ci rt mi1 it1 it2 n)
NestLoop(mi2 t kt ci rt mi1 it1 it2)
NestLoop(mi2 t kt ci rt mi1 it1)
NestLoop(mi2 t kt ci rt mi1)
NestLoop(mi2 t kt ci rt)
NestLoop(mi2 t kt ci)
NestLoop(mi2 t kt)
NestLoop(mi2 t)
IndexScan(mi1)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi2)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
Leading(((((((((mi2 t) kt) ci) rt) mi1) it1) it2) n))
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
(
    SELECT * FROM cast_info as ci
    WHERE 
pg_lip_bloom_probe(1, ci.movie_id) 
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
 AND (it1.id in ('18')) 
 AND (it2.id in ('17')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Big Ben, Houses of Parliament, Westminster, London, England, UK','CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Santa Clarita, California, USA','Spain','Stage 1, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA','Stage 5, Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA','Stage 8, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Washington, District of Columbia, USA')) 
 AND (mi2.info IN ('Last show of the series.','One of over 700 Paramount Productions, filmed between 1929 AND 1949, which were sold to MCA/Universal in 1958 for television distribution, AND have been owned AND controlled by Universal ever since.')) 
 AND (kt.kind in ('movie','video game')) 
 AND (rt.role in ('composer','guest','miscellaneous crew')) 
 AND (n.gender IN ('f') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1875) 
  
;