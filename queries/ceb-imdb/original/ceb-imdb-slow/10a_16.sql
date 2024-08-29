SELECT n.name,
       mi1.info,
       MIN(t.production_year),
       MAX(t.production_year)
FROM title AS t,
     kind_type AS kt,
     movie_info AS mi1,
     info_type AS it1,
     cast_info AS ci,
     role_type AS rt,
     name AS n
WHERE t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND mi1.info_type_id = it1.id
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.movie_id = mi1.movie_id
  AND ci.role_id = rt.id
  AND (it1.id IN ('2',
                  '4'))
  AND (mi1.info IN ('Arabic',
                    'Black and White',
                    'Cantonese',
                    'Color',
                    'Danish',
                    'Dutch',
                    'English',
                    'Filipino',
                    'French',
                    'German',
                    'Japanese',
                    'Korean',
                    'Latin',
                    'Mandarin',
                    'Portuguese',
                    'Spanish',
                    'Swedish',
                    'Tagalog'))
  AND (n.name ILIKE '%will%')
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('actor',
                   'cinematographer',
                   'composer',
                   'costume designer'))
GROUP BY mi1.info,
         n.name