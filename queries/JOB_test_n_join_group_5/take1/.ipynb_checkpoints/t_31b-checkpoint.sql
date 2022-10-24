/*+ NestLoop(k mk mc mi it1 ci cn n mi_idx it2 t)
 NestLoop(k mk mc mi it1 ci cn n mi_idx it2)
 NestLoop(k mk mc mi it1 ci cn n mi_idx)
 NestLoop(k mk mc mi it1 ci cn n)
 NestLoop(k mk mc mi it1 ci cn)
 NestLoop(k mk mc mi it1 ci)
 NestLoop(k mk mc mi it1)
 NestLoop(k mk mc mi)
 NestLoop(k mk mc)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(ci)
 IndexScan(cn)
 IndexScan(n)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 Leading(((((((((((k mk) mc) mi) it1) ci) cn) n) mi_idx) it2) t)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS violent_liongate_movie
FROM cast_info AS ci,
     company_name AS cn,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND cn.name LIKE 'Lionsgate%'
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mc.note LIKE '%(Blu-ray)%'
  AND mi.info IN ('Horror',
                  'Thriller')
  AND n.gender = 'm'
  AND t.production_year > 2000
  AND (t.title LIKE '%Freddy%'
       OR t.title LIKE '%Jason%'
       OR t.title LIKE 'Saw%')
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id;

