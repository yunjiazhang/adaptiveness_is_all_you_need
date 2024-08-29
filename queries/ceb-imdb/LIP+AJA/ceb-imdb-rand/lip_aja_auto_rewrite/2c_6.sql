SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 6) AND (mi1.info = ANY ('{Datasat,"Dolby Digital","Dolby SR",Dolby,SDDS}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi2.movie_id)), sum(pg_lip_bloom_add(2, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Argentina,Austria,Belgium,Denmark,Ireland,Italy,Poland,Portugal,"Soviet Union",Spain,Switzerland,"West Germany"}'::text[]))) AND ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Argentina,Austria,Belgium,Denmark,Ireland,Italy,Poland,Portugal,"Soviet Union",Spain,Switzerland,"West Germany"}'::text[])));


/*+
NestLoop(t kt mi1 it1 ci rt n mi2 it2)
NestLoop(t kt mi1 it1 ci rt n mi2)
NestLoop(t kt mi1 it1 ci rt n)
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
IndexScan(n)
SeqScan(it2)
SeqScan(kt)
SeqScan(t)
Leading(((((((((t kt) mi1) it1) ci) rt) n) mi2) it2))
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
 AND (it1.id in ('6')) 
 AND (it2.id in ('8')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('Datasat','Dolby Digital','Dolby SR','Dolby','SDDS')) 
 AND (mi2.info IN ('Argentina','Austria','Belgium','Denmark','Ireland','Italy','Poland','Portugal','Soviet Union','Spain','Switzerland','West Germany')) 
 AND (kt.kind in ('episode','movie','tv series','video game','video movie')) 
 AND (rt.role in ('actress','cinematographer','guest','producer','production designer')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 2015) 
 AND (t.production_year >= 1975) 
 AND (t.title in ('(#1.27)','(#1.2828)','(#6.152)','(2002-05-20)','(2011-11-09)','Fashion One Correspondent Search London','Finale: Part 2','Fix My Friend','Getting There','Rollerball','Where the Heart Is')) 
  
;