/*+ NestLoop(k mk t mi_idx it)
 NestLoop(k mk t mi_idx)
 NestLoop(k mk t)
 NestLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 SeqScan(it)
 Leading(((((k mk) t) mi_idx) it)) */
 SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM info_type AS it,
     keyword AS k,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it.info ='rating'
  AND k.keyword LIKE '%sequel%'
  AND mi_idx.info > '5.0'
  AND t.production_year > 2005
  AND t.id = mi_idx.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it.id = mi_idx.info_type_id;

