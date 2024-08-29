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
  AND (mi1.info IN ('Argentina:Atp',
                    'Australia:G',
                    'Germany:16',
                    'Iceland:12',
                    'Norway:16',
                    'Portugal:M/12',
                    'Singapore:NC-16',
                    'Sweden:Btl',
                    'UK:15',
                    'USA:G',
                    'USA:TV-14'))
  AND (mi2.info IN ('Dolby Digital',
                    'Mono'))
  AND (kt.kind IN ('movie',
                   'video movie'))
  AND (rt.role IN ('producer'))
  AND (n.gender IN ('m'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (k.keyword IN ('anal-sex',
                     'based-on-novel',
                     'dancing',
                     'family-relationships',
                     'father-daughter-relationship',
                     'female-nudity',
                     'fight',
                     'gay',
                     'homosexual',
                     'hospital',
                     'husband-wife-relationship',
                     'interview',
                     'kidnapping',
                     'one-word-title',
                     'police',
                     'sex',
                     'singing',
                     'song',
                     'violence'))