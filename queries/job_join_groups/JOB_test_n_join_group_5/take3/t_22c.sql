/*+ NestLoop(it2 k mk mi_idx t mc cn ct kt mi it1)
 NestLoop(it2 k mk mi_idx t mc cn ct kt mi)
 NestLoop(it2 k mk mi_idx t mc cn ct kt)
 NestLoop(it2 k mk mi_idx t mc cn ct)
 NestLoop(it2 k mk mi_idx t mc cn)
 NestLoop(it2 k mk mi_idx t mc)
 NestLoop(it2 k mk mi_idx t)
 NestLoop(it2 k mk mi_idx)
 NestLoop(k mk mi_idx)
 NestLoop(k mk)
 SeqScan(it2)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(kt)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((((it2 ((k mk) mi_idx)) t) mc) cn) ct) kt) mi) it1)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_violent_movie
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
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
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id;
