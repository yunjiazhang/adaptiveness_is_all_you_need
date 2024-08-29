SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 8) AND (mi2.info = ANY ('{Austria,Belgium,Brazil,Canada,Finland,Japan,Netherlands,Philippines,Poland,Portugal,Sweden,UK,Yugoslavia}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio 50, New York City, New York, USA","General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA","Lisbon, Portugal","London, England, UK",Mexico,"Montréal, Québec, Canada","Revue Studios, Hollywood, Los Angeles, California, USA","Shepperton Studios, Shepperton, Surrey, England, UK",Spain,"Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"CBS Studio 50, New York City, New York, USA","General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA","Lisbon, Portugal","London, England, UK",Mexico,"Montréal, Québec, Canada","Revue Studios, Hollywood, Los Angeles, California, USA","Shepperton Studios, Shepperton, Surrey, England, UK",Spain,"Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[])));


/*+
HashJoin(t kt mi2 ci rt n mi1 it1 it2)
HashJoin(t kt mi2 ci rt n mi1 it1)
NestLoop(t kt mi2 ci rt n mi1)
NestLoop(t kt mi2 ci rt n)
HashJoin(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
SeqScan(rt)
SeqScan(t)
Leading(((((((((t kt) mi2) ci) rt) n) mi1) it1) it2))
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
 AND (it1.id in ('18')) 
 AND (it2.id in ('8')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('CBS Studio 50, New York City, New York, USA','General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA','Lisbon, Portugal','London, England, UK','Mexico','Montréal, Québec, Canada','Revue Studios, Hollywood, Los Angeles, California, USA','Shepperton Studios, Shepperton, Surrey, England, UK','Spain','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
 AND (mi2.info IN ('Austria','Belgium','Brazil','Canada','Finland','Japan','Netherlands','Philippines','Poland','Portugal','Sweden','UK','Yugoslavia')) 
 AND (kt.kind in ('episode','movie','tv movie','video game','video movie')) 
 AND (rt.role in ('cinematographer','composer','guest','miscellaneous crew')) 
 AND (n.gender IN ('f')) 
 AND (t.production_year <= 1990) 
 AND (t.production_year >= 1950) 
 AND (t.title in ('(#1.141)','(#1.326)','(#1.410)','(#1.46)','(#1.82)','(#1.890)','(#1.969)','(#2.39)','(#6.13)','(#6.20)','(#7.3)','A Night to Remember','Adam','Assassin','Avenging Angel','Caged Fury','Competition','Dallas Cowboys vs. Washington Redskins','Del 4','Downtown','Empire of Ash','Ghostbusters II','Impasse','Jigsaw','Jo Jo Dancer, Your Life Is Calling','Kidnapped','La ciociara','Lamb to the Slaughter','Lawrence of Arabia','Lethal Weapon 2','Lies','Love Me or Leave Me','Masterpiece','One on One','Quo Vadis','Roadie','Running Scared','Spring Fever','Strange Bedfellows','Sunset','Testament','The Boys','The Idol','The Red Shoes','The Source','Touch AND Go','Working Girls','World Championship Wrestling')) 
  
;