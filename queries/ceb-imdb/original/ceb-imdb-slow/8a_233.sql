SELECT COUNT(*)
FROM title AS t,
     kind_type AS kt,
     info_type AS it1,
     movie_info AS mi1,
     cast_info AS ci,
     role_type AS rt,
     name AS n,
     movie_keyword AS mk,
     keyword AS k,
     movie_companies AS mc,
     company_type AS ct,
     company_name AS cn
WHERE t.id = ci.movie_id
  AND t.id = mc.movie_id
  AND t.id = mi1.movie_id
  AND t.id = mk.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND k.id = mk.keyword_id
  AND mi1.info_type_id = it1.id
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (it1.id IN ('3'))
  AND (mi1.info IN ('Comedy',
                    'Documentary',
                    'Drama'))
  AND (kt.kind IN ('tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'composer',
                   'costume designer',
                   'director',
                   'writer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.surname_pcode IN ('B6',
                           'C',
                           'D25',
                           'J52',
                           'L2',
                           'L235',
                           'M35',
                           'S532')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (cn.name IN ('ABS-CBN',
                   'American Broadcasting Company (ABC)',
                   'British Broadcasting Corporation (BBC)'))
  AND (ct.kind IN ('distributors',
                   'production companies'))