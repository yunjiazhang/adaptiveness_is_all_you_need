/*+ NestLoop(it2 k mk mi_idx t mi it1 kt)
 NestLoop(it2 k mk mi_idx t mi it1)
 NestLoop(it2 k mk mi_idx t mi)
 NestLoop(it2 k mk mi_idx t)
 NestLoop(it2 k mk mi_idx)
 NestLoop(k mk mi_idx)
 NestLoop(k mk)
 SeqScan(it2)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(kt)
 Leading((((((it2 ((k mk) mi_idx)) t) mi) it1) kt)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_dark_production
FROM info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title')
  AND kt.kind = 'movie'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info > '6.0'
  AND t.production_year > 2010
  AND (t.title LIKE '%murder%'
       OR t.title LIKE '%Murder%'
       OR t.title LIKE '%Mord%')
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;

