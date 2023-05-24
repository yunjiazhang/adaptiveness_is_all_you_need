/*+ NestLoop(it2 mi_idx t ci n mi it1)
 NestLoop(it2 mi_idx t ci n mi)
 NestLoop(it2 mi_idx t ci n)
 NestLoop(it2 mi_idx t ci)
 NestLoop(it2 mi_idx t)
 NestLoop(it2 mi_idx)
 IndexScan(it2)
 IndexScan(mi_idx)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((it2 mi_idx) t) ci) n) mi) it1)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(t.title) AS movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     name AS n,
     title AS t
WHERE ci.note IN ('(producer)',
                  '(executive producer)')
  AND it1.info = 'budget'
  AND it2.info = 'votes'
  AND n.gender = 'm'
  AND n.name LIKE '%Tim%'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;
