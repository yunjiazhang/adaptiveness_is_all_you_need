SELECT COUNT(*)
FROM title AS t,
     kind_type AS kt,
     info_type AS it1,
     movie_info AS mi1,
     movie_info AS mi2,
     info_type AS it2,
     cast_info AS ci,
     role_type AS rt,
     name AS n,
     movie_keyword AS mk,
     keyword AS k
WHERE t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND t.id = mi2.movie_id
  AND t.id = mk.movie_id
  AND k.id = mk.keyword_id
  AND mi1.movie_id = mi2.movie_id
  AND mi1.info_type_id = it1.id
  AND mi2.info_type_id = it2.id
  AND (it1.id IN ('3'))
  AND (it2.id IN ('4'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Action',
                    'Adult',
                    'Documentary',
                    'Drama',
                    'Reality-TV',
                    'Short',
                    'Talk-Show'))
  AND (mi2.info IN ('Dutch',
                    'English',
                    'French',
                    'Greek',
                    'Hindi'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('cinematographer',
                   'costume designer'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)