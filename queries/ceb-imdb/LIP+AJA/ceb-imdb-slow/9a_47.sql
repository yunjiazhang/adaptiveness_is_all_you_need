SELECT mi1.info,
       pi.info,
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
  AND (it1.id IN ('106'))
  AND (it2.id IN ('38'))
  AND (mi1.info ILIKE '%usa%')
  AND (pi.info ILIKE '%pla%')
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv mini series',
                   'tv movie',
                   'tv series',
                   'video movie'))
  AND (rt.role IN ('actress',
                   'director',
                   'editor',
                   'miscellaneous crew',
                   'producer'))
GROUP BY mi1.info,
         pi.info