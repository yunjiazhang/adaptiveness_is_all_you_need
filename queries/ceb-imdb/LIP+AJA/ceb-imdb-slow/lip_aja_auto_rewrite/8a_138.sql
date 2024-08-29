SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, mi1.movie_id)), sum(pg_lip_bloom_add(1, mi1.movie_id)) FROM movie_info AS mi1 
        WHERE ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","CBS Studio 50, New York City, New York, USA","CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Los Angeles, California, USA","Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA","Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[]))) AND ((mi1.info_type_id = 18) AND (mi1.info = ANY ('{"20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA","CBS Studio 50, New York City, New York, USA","CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA","Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA","Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA","Los Angeles, California, USA","Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA","Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA","Universal Studios - 100 Universal City Plaza, Universal City, California, USA","Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA"}'::text[])));
SELECT sum(pg_lip_bloom_add(2, n.id)) FROM name AS n 
        WHERE ((n.gender IS NULL) AND ((n.surname_pcode)::text = ANY ('{A645,B4,B5,C36,D12,G62,K52,L15,M252,N16,R362,S5}'::text[])));


/*+
NestLoop(cn mc ct t kt mi1 it1 mk ci rt n k)
HashJoin(cn mc ct t kt mi1 it1 mk ci rt n)
HashJoin(cn mc ct t kt mi1 it1 mk ci rt)
NestLoop(cn mc ct t kt mi1 it1 mk ci)
NestLoop(cn mc ct t kt mi1 it1 mk)
HashJoin(cn mc ct t kt mi1 it1)
NestLoop(cn mc ct t kt mi1)
HashJoin(cn mc ct t kt)
NestLoop(cn mc ct t)
HashJoin(cn mc ct)
NestLoop(cn mc)
IndexScan(mi1)
IndexScan(mc)
IndexScan(mk)
IndexScan(ci)
IndexScan(rt)
IndexScan(t)
SeqScan(it1)
IndexScan(n)
IndexScan(k)
SeqScan(cn)
SeqScan(ct)
SeqScan(kt)
Leading((((((((((((cn mc) ct) t) kt) mi1) it1) mk) ci) rt) n) k))
*/
 SELECT COUNT(*) 
 
FROM 
(
    SELECT * FROM title AS t
    WHERE 
pg_lip_bloom_probe(1, t.id) 
) AS t,
kind_type AS kt,
info_type AS it1,
movie_info AS mi1,
(
    SELECT * FROM cast_info AS ci
    WHERE 
pg_lip_bloom_probe(2, ci.person_id) 
) AS ci,
role_type AS rt,
name AS n,
movie_keyword AS mk,
keyword AS k,
(
    SELECT * FROM movie_companies AS mc
    WHERE 
pg_lip_bloom_probe(0, mc.movie_id) 
) AS mc,
company_type AS ct,
company_name AS cn
WHERE 
 t.id = ci.movie_id 
   AND t.id = mc.movie_id 
   AND t.id = mi1.movie_id 
   AND t.id = mk.movie_id 
   AND mc.company_type_id = ct.id 
   AND mc.company_id = cn.id 
   AND k.id = mk.keyword_id 
   AND mi1.info_type_id = it1.id 
   AND t.kind_id = kt.id 
   AND ci.person_id = n.id 
   AND ci.role_id = rt.id 
   AND (it1.id IN ('18')) 
   AND (mi1.info IN ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA', 
                     'CBS Studio 50, New York City, New York, USA', 
                     'CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA', 
                     'Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA', 
                     'Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA', 
                     'Los Angeles, California, USA', 
                     'Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA', 
                     'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA', 
                     'Universal Studios - 100 Universal City Plaza, Universal City, California, USA', 
                     'Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA')) 
   AND (kt.kind IN ('episode', 
                    'movie')) 
   AND (rt.role IN ('editor', 
                    'miscellaneous crew', 
                    'writer')) 
   AND (n.gender IS NULL) 
   AND (n.surname_pcode IN ('A645', 
                            'B4', 
                            'B5', 
                            'C36', 
                            'D12', 
                            'G62', 
                            'K52', 
                            'L15', 
                            'M252', 
                            'N16', 
                            'R362', 
                            'S5')) 
   AND (t.production_year <= 2015) 
   AND (t.production_year >= 1925) 
   AND (cn.name IN ('ABS-CBN', 
                    'American Broadcasting Company (ABC)', 
                    'British Broadcasting Corporation (BBC)', 
                    'Columbia Broadcasting System (CBS)', 
                    'Granada Television', 
                    'National Broadcasting Company (NBC)', 
                    'Warner Bros. Television', 
                    'Warner Home Video')) 
   AND (ct.kind IN ('distributors', 
                    'production companies')) 
;