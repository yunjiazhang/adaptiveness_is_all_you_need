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
  AND (it1.id IN ('6'))
  AND (mi1.info IN ('DTS',
                    'Dolby Digital',
                    'Dolby SR',
                    'Dolby',
                    'Mono',
                    'SDDS',
                    'Silent',
                    'Stereo'))
  AND (n.name ILIKE '%mark%')
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'cinematographer',
                   'costume designer'))
GROUP BY mi1.info,
         n.name