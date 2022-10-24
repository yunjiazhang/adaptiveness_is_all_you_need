/*+ HashJoin(chn cct2 cc mi_idx ci k mk n t kt cct1 it2)
 MergeJoin(chn cct2 cc mi_idx ci k mk n t kt cct1)
 NestLoop(cct2 cc mi_idx ci k mk n t kt cct1)
 HashJoin(cct2 cc mi_idx ci k mk n t kt)
 MergeJoin(cc mi_idx ci k mk n t kt)
 NestLoop(mi_idx ci k mk n t kt)
 HashJoin(mi_idx ci k mk n t)
 NestLoop(ci k mk n t)
 HashJoin(ci k mk n)
 HashJoin(ci k mk)
 NestLoop(k mk)
 SeqScan(chn)
 IndexScan(cct2)
 IndexScan(cc)
 IndexScan(mi_idx)
 SeqScan(ci)
 SeqScan(k)
 IndexScan(mk)
 SeqScan(n)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(cct1)
 SeqScan(it2)
 Leading(((chn ((cct2 (cc ((mi_idx (((ci (k mk)) n) t)) kt))) cct1)) it2)) */
SELECT MIN(chn.name) AS character_name,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_hero_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND it2.info = 'rating'
  AND k.keyword IN ('superhero',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence',
                    'magnet',
                    'web',
                    'claw',
                    'laser')
  AND kt.kind = 'movie'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND ci.movie_id = cc.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND cc.movie_id = mi_idx.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND it2.id = mi_idx.info_type_id;

