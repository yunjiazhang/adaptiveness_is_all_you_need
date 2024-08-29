SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 5) AND (mi2.info = ANY ('{Argentina:13,Brazil:14,Finland:K-12,Finland:K-16,Finland:K-18,France:-12,Italy:VM18,Norway:16,Sweden:Btl,USA:PG,USA:TV-G,USA:TV-PG,USA:X,"West Germany:16"}'::text[])));


/*+
NestLoop(mi1 t kt mi2 ci rt it1 it2 n)
HashJoin(mi1 t kt mi2 ci rt it1 it2)
HashJoin(mi1 t kt mi2 ci rt it1)
NestLoop(mi1 t kt mi2 ci rt)
NestLoop(mi1 t kt mi2 ci)
NestLoop(mi1 t kt mi2)
NestLoop(mi1 t kt)
NestLoop(mi1 t)
IndexScan(mi2)
IndexScan(kt)
IndexScan(ci)
IndexScan(rt)
SeqScan(mi1)
IndexScan(t)
SeqScan(it1)
SeqScan(it2)
IndexScan(n)
Leading(((((((((mi1 t) kt) mi2) ci) rt) it1) it2) n))
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
 AND (it1.id in ('18')) 
 AND (it2.id in ('5')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Denham Studios, Denham, Buckinghamshire, England, UK','Janss Conejo Ranch, Thousand Oaks, California, USA','London, England, UK','Pinewood Studios, Iver Heath, Buckinghamshire, England, UK','Rome, Lazio, Italy','San Francisco, California, USA','Twickenham Film Studios, St Margarets, Twickenham, Middlesex, England, UK')) 
 AND (mi2.info IN ('Argentina:13','Brazil:14','Finland:K-12','Finland:K-16','Finland:K-18','France:-12','Italy:VM18','Norway:16','Sweden:Btl','USA:PG','USA:TV-G','USA:TV-PG','USA:X','West Germany:16')) 
 AND (kt.kind in ('episode','tv movie','tv series','video game','video movie')) 
 AND (rt.role in ('director')) 
 AND (n.gender IN ('m') OR n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
  
;