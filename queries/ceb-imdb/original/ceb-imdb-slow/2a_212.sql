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
  AND (it1.id IN ('5'))
  AND (it2.id IN ('6'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Argentina:16',
                    'Argentina:18',
                    'Australia:M',
                    'Finland:(Banned)',
                    'Finland:K-18',
                    'Germany:12',
                    'Iceland:12',
                    'Portugal:M/12',
                    'Singapore:PG',
                    'Spain:18',
                    'UK:A',
                    'USA:G',
                    'USA:Passed'))
  AND (mi2.info IN ('Dolby',
                    'Mono'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('actress',
                   'composer'))
  AND (n.gender IN ('m'))
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)