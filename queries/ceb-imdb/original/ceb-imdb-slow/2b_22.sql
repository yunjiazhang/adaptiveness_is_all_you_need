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
  AND (it1.id IN ('2'))
  AND (it2.id IN ('1'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Black and White',
                    'Color'))
  AND (mi2.info IN ('10',
                    '104',
                    '15',
                    '17',
                    '19',
                    '55',
                    '58',
                    '75',
                    '85',
                    '87',
                    '90',
                    '99',
                    'USA:11',
                    'USA:12',
                    'USA:13'))
  AND (kt.kind IN ('movie',
                   'video movie'))
  AND (rt.role IN ('miscellaneous crew'))
  AND (n.gender IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (k.keyword IN ('bare-breasts',
                     'bare-chested-male',
                     'based-on-play',
                     'dancing',
                     'death',
                     'hardcore',
                     'homosexual',
                     'hospital',
                     'independent-film',
                     'lesbian',
                     'love',
                     'mother-daughter-relationship',
                     'murder',
                     'new-york-city',
                     'nudity',
                     'number-in-title',
                     'one-word-title',
                     'police',
                     'revenge',
                     'singer',
                     'singing'))