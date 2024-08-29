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
  AND (mi1.info IN ('Animation',
                    'Biography',
                    'Crime',
                    'Documentary',
                    'Drama',
                    'Family',
                    'Musical',
                    'Short'))
  AND (mi2.info IN ('Danish',
                    'French',
                    'German',
                    'Hindi',
                    'Japanese',
                    'Norwegian',
                    'Romanian',
                    'Russian',
                    'Spanish'))
  AND (kt.kind IN ('movie',
                   'video movie'))
  AND (rt.role IN ('actress',
                   'miscellaneous crew'))
  AND (n.gender IN ('f'))
  AND (t.production_year <= 2010)
  AND (t.production_year >= 1950)
  AND (k.keyword IN ('based-on-play',
                     'character-name-in-title',
                     'cigarette-smoking',
                     'dog',
                     'flashback',
                     'jealousy',
                     'lesbian',
                     'lesbian-sex',
                     'love',
                     'male-frontal-nudity',
                     'mother-son-relationship',
                     'number-in-title',
                     'one-word-title',
                     'police',
                     'revenge',
                     'sequel',
                     'song',
                     'suicide'))