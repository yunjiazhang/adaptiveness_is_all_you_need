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
  AND (it1.id IN ('6'))
  AND (it2.id IN ('5'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('DTS',
                    'Dolby Digital',
                    'SDDS'))
  AND (mi2.info IN ('Canada:G',
                    'Iceland:12',
                    'Norway:15',
                    'Spain:18'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('actor'))
  AND (n.gender IN ('m'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (k.keyword IN ('based-on-novel',
                     'cigarette-smoking',
                     'father-daughter-relationship',
                     'female-nudity',
                     'flashback',
                     'hospital',
                     'lesbian-sex',
                     'marriage',
                     'mother-daughter-relationship',
                     'murder',
                     'police',
                     'sequel',
                     'violence'))