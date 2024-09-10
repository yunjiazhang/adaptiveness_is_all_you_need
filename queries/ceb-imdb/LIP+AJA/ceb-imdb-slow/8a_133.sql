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
  AND (it1.id IN ('7'))
  AND (mi1.info IN ('OFM:Video',
                    'PFM:35 mm',
                    'RAT:1.33 : 1',
                    'RAT:1.37 : 1'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('actress',
                   'costume designer',
                   'director',
                   'miscellaneous crew',
                   'writer'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (n.surname_pcode IN ('B6',
                           'B62',
                           'C5',
                           'H2',
                           'H4',
                           'J52',
                           'L',
                           'M6',
                           'R2',
                           'S5')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'British Broadcasting Corporation (BBC)',
                   'National Broadcasting Company (NBC)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))