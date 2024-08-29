SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)), sum(pg_lip_bloom_add(1, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"OFM:35 mm",PCS:Spherical,"PFM:35 mm"}'::text[]))) AND ((mi2.info_type_id = 7) AND (mi2.info = ANY ('{"OFM:35 mm",PCS:Spherical,"PFM:35 mm"}'::text[])));


/*+
NestLoop(mi1 t kt it1 mk ci rt mi2 it2 n k)
NestLoop(mi1 t kt it1 mk ci rt mi2 it2 n)
NestLoop(mi1 t kt it1 mk ci rt mi2 it2)
NestLoop(mi1 t kt it1 mk ci rt mi2)
NestLoop(mi1 t kt it1 mk ci rt)
NestLoop(mi1 t kt it1 mk ci)
NestLoop(mi1 t kt it1 mk)
NestLoop(mi1 t kt it1)
NestLoop(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(kt)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
IndexScan(k)
Leading(((((((((((mi1 t) kt) it1) mk) ci) rt) mi2) it2) n) k))
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
 AND (it1.id in ('17')) 
 AND (it2.id in ('7')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info in ('One of over 700 Paramount Productions, filmed between 1929 AND 1949, which were sold to MCA/Universal in 1958 for television distribution, AND have been owned AND controlled by Universal ever since.')) 
 AND (mi2.info in ('OFM:35 mm','PCS:Spherical','PFM:35 mm')) 
 AND (kt.kind in ('episode','movie','tv movie')) 
 AND (rt.role in ('composer')) 
 AND (n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;