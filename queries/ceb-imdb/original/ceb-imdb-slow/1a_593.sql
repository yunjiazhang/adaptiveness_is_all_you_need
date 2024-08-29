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
  AND it2.id = '4'
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND mi1.info IN ('Action',
                   'Adult',
                   'Comedy',
                   'Documentary',
                   'Drama',
                   'Horror',
                   'Short',
                   'Talk-Show')
  AND mi2.info IN ('Cantonese',
                   'English',
                   'Filipino',
                   'Hebrew',
                   'Japanese',
                   'Spanish',
                   'Turkish')
  AND kt.kind IN ('episode',
                  'movie',
                  'video movie')
  AND rt.role IN ('actor',
                  'actress')
  AND n.gender IN ('f',
                   'm')
  AND t.production_year <= 2015
  AND 1975 < t.production_year