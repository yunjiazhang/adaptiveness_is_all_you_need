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
  AND it1.id = '8'
  AND it2.id = '4'
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND mi1.info IN ('Belgium',
                   'Brazil',
                   'Germany',
                   'India',
                   'Mexico',
                   'Netherlands',
                   'Romania',
                   'Soviet Union',
                   'Taiwan',
                   'Turkey',
                   'USA')
  AND mi2.info IN ('Dutch',
                   'English',
                   'German',
                   'Malayalam',
                   'Mandarin',
                   'Portuguese',
                   'Romanian',
                   'Russian',
                   'Spanish',
                   'Turkish')
  AND kt.kind IN ('episode',
                  'movie',
                  'video movie')
  AND rt.role IN ('director',
                  'miscellaneous crew')
  AND n.gender IN ('m')
  AND t.production_year <= 2015
  AND 1925 < t.production_year