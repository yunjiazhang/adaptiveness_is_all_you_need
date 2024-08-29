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
  AND (it1.id IN ('8'))
  AND (it2.id IN ('6'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Austria',
                    'Belgium',
                    'Brazil',
                    'Hungary',
                    'India',
                    'Mexico',
                    'Poland',
                    'Spain'))
  AND (mi2.info IN ('Mono',
                    'Silent'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('costume designer',
                   'production designer'))
  AND (n.gender IS NULL)
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1875)
  AND (k.keyword IN ('based-on-play',
                     'cigarette-smoking',
                     'friendship',
                     'independent-film',
                     'jealousy',
                     'lesbian-sex',
                     'male-nudity',
                     'marriage',
                     'mother-daughter-relationship',
                     'one-word-title',
                     'oral-sex',
                     'police',
                     'singing',
                     'song'))