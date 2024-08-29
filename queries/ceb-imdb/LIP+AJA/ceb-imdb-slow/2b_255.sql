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
  AND (it1.id IN ('7'))
  AND (it2.id IN ('8'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('CAM:Panavision Cameras and Lenses',
                    'OFM:16 mm',
                    'OFM:35 mm',
                    'OFM:Video',
                    'PCS:Spherical',
                    'PFM:35 mm',
                    'RAT:1.33 : 1',
                    'RAT:1.37 : 1',
                    'RAT:1.66 : 1',
                    'RAT:1.78 : 1',
                    'RAT:2.35 : 1',
                    'RAT:4:3'))
  AND (mi2.info IN ('East Germany',
                    'Hong Kong',
                    'Italy',
                    'Taiwan',
                    'UK',
                    'USA',
                    'West Germany'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('production designer'))
  AND (n.gender IN ('f'))
  AND (t.production_year <= 2010)
  AND (t.production_year >= 1950)
  AND (k.keyword IN ('death',
                     'father-son-relationship',
                     'fight',
                     'gay',
                     'independent-film',
                     'lesbian-sex',
                     'mother-daughter-relationship',
                     'murder',
                     'number-in-title'))