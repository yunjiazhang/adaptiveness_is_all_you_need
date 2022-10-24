/*+ NestLoop(t k mk ci n)
 NestLoop(t k mk ci)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 Leading((((t (k mk)) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS marvel_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword = 'marvel-cinematic-universe'
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2000
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;

