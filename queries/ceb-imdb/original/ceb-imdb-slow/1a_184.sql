SELECT COUNT(*)
FROM title AS t,
     kind_type AS kt,
     movie_info AS mi1,
     info_type AS it1,
     movie_info AS mi2,
     info_type AS it2,
     cast_info AS ci,
     role_type AS rt,
     name AS n
WHERE t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND t.id = mi2.movie_id
  AND mi1.movie_id = mi2.movie_id
  AND mi1.info_type_id = it1.id
  AND mi2.info_type_id = it2.id
  AND it1.id = '3'
  AND it2.id = '7'
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND mi1.info IN ('Adventure',
                   'Comedy',
                   'Crime',
                   'Documentary',
                   'Drama',
                   'Horror',
                   'Music',
                   'Romance',
                   'Sci-Fi',
                   'Short')
  AND mi2.info IN ('MET:300 m',
                   'OFM:35 mm',
                   'OFM:Video',
                   'PCS:Digital Intermediate',
                   'PFM:35 mm',
                   'RAT:1.85 : 1',
                   'RAT:2.35 : 1')
  AND kt.kind IN ('episode',
                  'movie',
                  'video movie')
  AND rt.role IN ('producer')
  AND n.gender IN ('m')
  AND t.production_year <= 2015
  AND 1925 < t.production_year