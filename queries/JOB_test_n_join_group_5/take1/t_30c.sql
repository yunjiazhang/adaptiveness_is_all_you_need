/*+ HashJoin(cct2 it2 ci n k mk t mi_idx cc cct1 mi it1)
 NestLoop(cct2 it2 ci n k mk t mi_idx cc cct1 mi)
 NestLoop(cct2 it2 ci n k mk t mi_idx cc cct1)
 NestLoop(it2 ci n k mk t mi_idx cc cct1)
 HashJoin(it2 ci n k mk t mi_idx cc)
 NestLoop(it2 ci n k mk t mi_idx)
 NestLoop(ci n k mk t mi_idx)
 NestLoop(ci n k mk t)
 HashJoin(ci n k mk)
 NestLoop(k mk)
 HashJoin(ci n)
 SeqScan(cct2)
 SeqScan(it2)
 SeqScan(ci)
 SeqScan(n)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 SeqScan(cc)
 IndexScan(cct1)
 IndexScan(mi)
 SeqScan(it1)
 Leading((((cct2 (((it2 ((((ci n) (k mk)) t) mi_idx)) cc) cct1)) mi) it1)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS complete_violent_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind ='complete+verified'
  AND ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Action',
                  'Sci-Fi',
                  'Thriller',
                  'Crime',
                  'War')
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;

