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
  AND (it2.id IN ('7'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Canada',
                    'East Germany',
                    'France',
                    'Italy',
                    'Japan',
                    'UK',
                    'USA'))
  AND (mi2.info IN ('OFM:16 mm',
                    'OFM:35 mm',
                    'PCS:Spherical',
                    'PFM:16 mm',
                    'PFM:35 mm',
                    'RAT:1.66 : 1',
                    'RAT:1.85 : 1',
                    'RAT:2.35 : 1'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('actress'))
  AND (n.gender IN ('m'))
  AND (t.production_year <= 2010)
  AND (t.production_year >= 1950)
  AND (k.keyword IN ('bare-breasts',
                     'blood',
                     'family-relationships',
                     'father-son-relationship',
                     'friendship',
                     'hospital',
                     'independent-film',
                     'interview',
                     'jealousy',
                     'kidnapping',
                     'lesbian-sex',
                     'male-frontal-nudity',
                     'male-nudity',
                     'mother-daughter-relationship',
                     'new-york-city',
                     'number-in-title',
                     'one-word-title',
                     'party',
                     'revenge',
                     'sex',
                     'song',
                     'suicide',
                     'violence'))