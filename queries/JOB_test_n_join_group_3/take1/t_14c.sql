/*+ NestLoop(k mk t kt mi it1 mi_idx it2)
 NestLoop(k mk t kt mi it1 mi_idx)
 NestLoop(k mk t kt mi it1)
 NestLoop(k mk t kt mi)
 NestLoop(k mk t kt)
 NestLoop(k mk t)
 NestLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading((((((((k mk) t) kt) mi) it1) mi_idx) it2)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS north_european_dark_production
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
  AND k.keyword IS NOT NULL
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
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

