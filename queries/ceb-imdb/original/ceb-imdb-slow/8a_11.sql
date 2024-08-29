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
  AND (it1.id IN ('2'))
  AND (mi1.info IN ('Black and White',
                    'Color'))
  AND (kt.kind IN ('episode',
                   'tv movie'))
  AND (rt.role IN ('actress',
                   'miscellaneous crew',
                   'writer'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (n.surname_pcode IN ('B2',
                           'B6',
                           'B62',
                           'B653',
                           'C2',
                           'C5',
                           'J52',
                           'J525',
                           'L15',
                           'L52',
                           'M62',
                           'P62',
                           'R3',
                           'W425'))
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'Columbia Broadcasting System (CBS)',
                   'National Broadcasting Company (NBC)'))
  AND (ct.kind IN ('distributors'))