SELECT n.gender,
       rt.role,
       cn.name,
       COUNT(*)
FROM title AS t,
     movie_companies AS mc,
     company_name AS cn,
     company_type AS ct,
     kind_type AS kt,
     cast_info AS ci,
     name AS n,
     role_type AS rt,
     movie_info AS mi1,
     info_type AS it
WHERE t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND mi1.movie_id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND kt.id = t.kind_id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND mi1.info_type_id = it.id
  AND (kt.kind ILIKE '%m%')
  AND (rt.role IN ('actor',
                   'actress',
                   'cinematographer',
                   'composer',
                   'costume designer',
                   'editor',
                   'miscellaneous crew',
                   'production designer'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (it.id IN ('4'))
  AND (mi1.info ILIKE '%i%')
  AND (cn.name ILIKE '%ho%')
GROUP BY n.gender,
         rt.role,
         cn.name
ORDER BY COUNT(*) DESC