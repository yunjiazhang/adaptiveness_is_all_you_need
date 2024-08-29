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
  AND (it2.id IN ('6'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA',
                    'MET:',
                    'MET:100 m',
                    'MET:15.2 m',
                    'MET:1500 m',
                    'MET:23 m',
                    'MET:30 m',
                    'MET:300 m',
                    'PCS:Panavision',
                    'PCS:Techniscope',
                    'PFM:16 mm',
                    'PFM:68 mm',
                    'RAT:1.36 : 1',
                    'RAT:1.37 : 1'))
  AND (mi2.info IN ('Mono',
                    'Silent'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('director',
                   'producer'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1875)
  AND (k.keyword IN ('based-on-play',
                     'doctor',
                     'hardcore',
                     'jealousy',
                     'new-york-city',
                     'one-word-title'))