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
  AND (it2.id IN ('8'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Dolby Digital',
                    'Dolby SR',
                    'Dolby',
                    'Stereo'))
  AND (mi2.info IN ('Australia',
                    'Belgium',
                    'Canada',
                    'France',
                    'Germany',
                    'Japan',
                    'UK',
                    'USA'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('director',
                   'production designer'))
  AND (n.gender IN ('f'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (k.keyword IN ('bare-breasts',
                     'bare-chested-male',
                     'character-name-in-title',
                     'dancing',
                     'doctor',
                     'family-relationships',
                     'female-nudity',
                     'flashback',
                     'interview',
                     'male-frontal-nudity',
                     'murder',
                     'non-fiction',
                     'party',
                     'revenge',
                     'singer',
                     'singing',
                     'suicide',
                     'surrealism',
                     'tv-mini-series'))