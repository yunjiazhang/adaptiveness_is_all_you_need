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
  AND (it2.id IN ('7'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('70 mm 6-Track',
                    'DTS',
                    'Dolby Digital',
                    'Dolby',
                    'Mono',
                    'SDDS'))
  AND (mi2.info IN ('CAM:Panavision Cameras and Lenses',
                    'LAB:DeLuxe, Hollywood (CA), USA',
                    'MET:300 m',
                    'PCS:CinemaScope',
                    'PCS:Shawscope',
                    'PCS:Techniscope',
                    'PFM:70 mm',
                    'PFM:D-Cinema',
                    'PFM:Digital',
                    'RAT:16:9 HD',
                    'RAT:2.35 : 1'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('editor',
                   'miscellaneous crew'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (k.keyword IN ('based-on-play',
                     'dancing',
                     'number-in-title',
                     'sex',
                     'suicide'))