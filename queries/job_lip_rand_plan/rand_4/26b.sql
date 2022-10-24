/*+
HashJoin(cc cct1 mi_idx mk k ci n t it2 chn kt cct2)
HashJoin(cc cct1 mi_idx mk k ci n t it2 chn kt)
HashJoin(cc cct1 mi_idx mk k ci n t it2 chn)
HashJoin(cc cct1 mi_idx mk k ci n t it2)
HashJoin(cc cct1 mi_idx mk k ci n t)
HashJoin(cc cct1 mi_idx mk k ci n)
HashJoin(cc cct1 mi_idx mk k ci)
HashJoin(cc cct1 mi_idx mk k)
HashJoin(cc cct1 mi_idx mk)
HashJoin(cc cct1 mi_idx)
HashJoin(cc cct1)
Leading((((((((((((cc cct1) mi_idx) mk) k) ci) n) t) it2) chn) kt) cct2))*/
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
                    'fight')
  AND kt.kind = 'movie'
  AND mi_idx.info > '8.0'
  AND t.production_year > 2005
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
