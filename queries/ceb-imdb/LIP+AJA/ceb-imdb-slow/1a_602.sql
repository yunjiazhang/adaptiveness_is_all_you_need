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
  AND it2.id = '5'
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND mi1.info IN ('Action',
                   'Adventure',
                   'Drama',
                   'Family',
                   'Mystery',
                   'Romance',
                   'Thriller')
  AND mi2.info IN ('Argentina:16',
                   'Brazil:14',
                   'Canada:13+',
                   'Finland:K-16',
                   'France:-12',
                   'Hong Kong:IIB',
                   'Hong Kong:III',
                   'Ireland:15A',
                   'South Korea:All',
                   'Spain:13',
                   'UK:U')
  AND kt.kind IN ('movie',
                  'video movie')
  AND rt.role IN ('actress')
  AND n.gender IN ('f')
  AND t.production_year <= 2015
  AND 1925 < t.production_year