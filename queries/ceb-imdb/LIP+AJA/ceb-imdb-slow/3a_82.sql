SELECT COUNT(*)
FROM title AS t,
     movie_keyword AS mk,
     keyword AS k,
     movie_companies AS mc,
     company_name AS cn,
     company_type AS ct,
     kind_type AS kt,
     cast_info AS ci,
     name AS n,
     role_type AS rt
WHERE t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mk.movie_id = mc.movie_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND kt.id = t.kind_id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (k.keyword IN ('anal-sex',
                     'based-on-novel',
                     'based-on-play',
                     'cigarette-smoking',
                     'dancing',
                     'doctor',
                     'father-daughter-relationship',
                     'new-york-city',
                     'non-fiction',
                     'number-in-title',
                     'suicide'))
  AND (cn.country_code IN ('[at]',
                           '[de]',
                           '[dk]',
                           '[fi]',
                           '[fr]',
                           '[gr]',
                           '[hk]',
                           '[hu]'))
  AND (ct.kind IN ('distributors',
                   'production companies'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('composer'))
  AND (n.gender IN ('f'))