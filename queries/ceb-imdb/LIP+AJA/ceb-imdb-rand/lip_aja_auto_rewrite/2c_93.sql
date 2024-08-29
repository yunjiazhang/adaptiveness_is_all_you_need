SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi2.movie_id)) FROM movie_info AS mi2 
        WHERE ((mi2.info_type_id = 3) AND (mi2.info = ANY ('{Adventure,Comedy,History,Musical,Mystery,Sci-Fi,Sport,Thriller,Western}'::text[])));
SELECT sum(pg_lip_bloom_add(1, mi1.movie_id)), sum(pg_lip_bloom_add(2, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","Acapulco, Guerrero, Mexico","Bavaria Filmstudios, Geiselgasteig, Grünwald, Bavaria, Germany","Corriganville, Ray Corrigan Ranch, Simi Valley, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Hong Kong, China","Los Angeles, California, USA","Madrid, Spain","Manhattan, New York City, New York, USA","Mexico City, Distrito Federal, Mexico","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Paris, France","San Francisco, California, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","Acapulco, Guerrero, Mexico","Bavaria Filmstudios, Geiselgasteig, Grünwald, Bavaria, Germany","Corriganville, Ray Corrigan Ranch, Simi Valley, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Hong Kong, China","Los Angeles, California, USA","Madrid, Spain","Manhattan, New York City, New York, USA","Mexico City, Distrito Federal, Mexico","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Paris, France","San Francisco, California, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA"}'::text[])));


/*+
HashJoin(t kt mi2 ci rt n mi1 it1 it2)
NestLoop(t kt mi2 ci rt n mi1 it1)
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
 AND (it2.id in ('3')) 
 AND t.kind_id = kt.id 
 AND ci.person_id = n.id 
 AND ci.role_id = rt.id 
 AND (mi1.info IN ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Acapulco, Guerrero, Mexico','Bavaria Filmstudios, Geiselgasteig, Grünwald, Bavaria, Germany','Corriganville, Ray Corrigan Ranch, Simi Valley, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Hong Kong, China','Los Angeles, California, USA','Madrid, Spain','Manhattan, New York City, New York, USA','Mexico City, Distrito Federal, Mexico','Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA','Paris, France','San Francisco, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA')) 
 AND (mi2.info IN ('Adventure','Comedy','History','Musical','Mystery','Sci-Fi','Sport','Thriller','Western')) 
 AND (kt.kind in ('movie','tv movie','tv series','video movie')) 
 AND (rt.role in ('costume designer')) 
 AND (n.gender IS NULL) 
 AND (t.production_year <= 1975) 
 AND (t.production_year >= 1925) 
 AND (t.title in ('(#1.11)','(#1.17)','(#1.85)','(#3.43)','(#5.27)','A Piece of the Action','Accidents Will Happen','Born to Sing','Carrie','College Holiday','Cornered','Der Rosenkavalier','Diane','East Side, West Side','Exposed','Forbidden','Forever AND a Day','Glückspilze','God Is My Co-Pilot','Jigsaw','La porteuse de pain','Les trois mousquetaires','Maratón','Roughly Speaking','Scandal Sheet','Seishun to wa nanda','Sing a Song of Murder','Springtime in the Rockies','Stagecoach','Stand Up AND Be Counted','The Bait','The Big Night','The Circus','The Decision','The Facts of Life','The Final Hour','The Greatest Show on Earth','The Hard Way','The Taming of the Shrew','The Turning Point','The Visitor','Thérèse Raquin','Yankee Doodle Dandy')) 
  
;