SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Action,Animation,Family,Fantasy,History,Horror,Music,Musical,Romance,Sci-Fi,Short,Western}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",OFM:Live,PCS:Panavision,PCS:Tohoscope,PCS:Totalscope,"PFM:16 mm","PFM:8 mm","RAT:1.33 : 1","RAT:1.66 : 1"}'::text[]))) AND ((mi1.info_type_id = 7) AND (mi1.info = ANY ('{"LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA",OFM:Live,PCS:Panavision,PCS:Tohoscope,PCS:Totalscope,"PFM:16 mm","PFM:8 mm","RAT:1.33 : 1","RAT:1.66 : 1"}'::text[])));


/*+
NestLoop(t kt mi2 ci rt n mi1 it1 it2)
NestLoop(t kt mi2 ci rt n mi1 it1)
NestLoop(t kt mi2 ci rt n mi1)
NestLoop(t kt mi2 ci rt n)
NestLoop(t kt mi2 ci rt)
NestLoop(t kt mi2 ci)
NestLoop(t kt mi2)
HashJoin(t kt)
IndexScan(mi2)
IndexScan(mi1)
IndexScan(ci)
IndexScan(rt)
IndexScan(n)
SeqScan(it1)
SeqScan(it2)
SeqScan(kt)
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
 AND (it1.id in ('7')) 
 AND (it2.id in ('3')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA','OFM:Live','PCS:Panavision','PCS:Tohoscope','PCS:Totalscope','PFM:16 mm','PFM:8 mm','RAT:1.33 : 1','RAT:1.66 : 1')) 
 AND (mi2.info IN ('Action','Animation','Family','Fantasy','History','Horror','Music','Musical','Romance','Sci-Fi','Short','Western')) 
 AND (kt.kind in ('tv movie','video game','video movie')) 
 AND (rt.role in ('cinematographer','guest')) 
 AND (n.gender IN ('m')) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.82)','(#2.12)','(#5.17)','(#6.12)','(#6.20)','(#7.17)','A Place in the Sun','Anastasia','Arsenic AND Old Lace','Bad Guy','Barabbas','Cold Turkey','Deadlock','Forever Amber','Full Circle','God Is My Co-Pilot','High Stakes','Johnny Belinda','Letter FROM an Unknown Woman','Million Dollar Baby','One Good Turn','Running Wild','Sweet Rosie OGrady','The Arizona Kid','The Contract','The Dream','The Good Companions','The Great Race','The Hunt','The Little Minister','The Mark of Cain','The Night Riders','The Runaways','The Stranger','The Swinger','Today','Tonka','Under Two Flags','With This Ring')) 
  
;