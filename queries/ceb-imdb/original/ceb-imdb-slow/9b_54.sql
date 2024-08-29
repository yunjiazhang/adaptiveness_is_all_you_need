SELECT mi1.info,
       n.name,
       COUNT(*)
FROM title AS t,
     kind_type AS kt,
     movie_info AS mi1,
     info_type AS it1,
     cast_info AS ci,
     role_type AS rt,
     name AS n,
     info_type AS it2,
     person_info AS pi
WHERE t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND mi1.info_type_id = it1.id
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.movie_id = mi1.movie_id
  AND ci.role_id = rt.id
  AND n.id = pi.person_id
  AND pi.info_type_id = it2.id
  AND (it1.id IN ('2',
                  '4',
                  '6'))
  AND (it2.id IN ('24'))
  AND (mi1.info IN ('70 mm 6-Track',
                    'Black and White',
                    'Color',
                    'Czech',
                    'Dolby',
                    'Dutch',
                    'English',
                    'French',
                    'German',
                    'Hindi',
                    'Hungarian',
                    'Italian',
                    'Norwegian',
                    'Portuguese',
                    'Russian',
                    'Spanish'))
  AND (n.name ILIKE '%ver%')
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'costume designer'))
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
GROUP BY mi1.info,
         n.name