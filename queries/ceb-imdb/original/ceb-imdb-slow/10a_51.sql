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
  AND (it1.id IN ('3',
                  '4'))
  AND (mi1.info IN ('Biography',
                    'Crime',
                    'Dutch',
                    'English',
                    'Fantasy',
                    'French',
                    'German',
                    'Musical',
                    'Mystery',
                    'Portuguese',
                    'Romance'))
  AND (n.name ILIKE '%rie%')
  AND (kt.kind IN ('episode',
                   'tv movie'))
  AND (rt.role IN ('director',
                   'editor',
                   'miscellaneous crew',
                   'producer'))
GROUP BY mi1.info,
         n.name