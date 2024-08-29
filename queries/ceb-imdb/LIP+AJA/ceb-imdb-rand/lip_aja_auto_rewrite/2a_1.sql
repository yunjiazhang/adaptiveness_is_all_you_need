SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 2) AND (mi2.info = 'Color'::text));


/*+
NestLoop(mi1 t kt mi2 it1 it2 ci rt n mk k)
NestLoop(mi1 t kt mi2 it1 it2 ci rt n mk)
NestLoop(mi1 t kt mi2 it1 it2 ci rt n)
NestLoop(mi1 t kt mi2 it1 it2 ci rt)
NestLoop(mi1 t kt mi2 it1 it2 ci)
HashJoin(mi1 t kt mi2 it1 it2)
HashJoin(mi1 t kt mi2 it1)
NestLoop(mi1 t kt mi2)
NestLoop(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
IndexScan(mk)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
Leading(((((((((((mi1 t) kt) mi2) it1) it2) ci) rt) n) mk) k))
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
 AND (it1.id in ('105')) 
 AND (it2.id in ('2')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('$12,000','$2,000,000','$2,500','$200','$300','$35,000','$40,000','$5,000,000','$6,000','$8,000','£1,000','£10,000','€ 1,000','€ 10,000','€ 5,000')) 
 AND (mi2.info in ('Color')) 
 AND (kt.kind in ('episode','video movie')) 
 AND (rt.role in ('actor')) 
 AND (n.gender in ('m')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1990) 
  
;