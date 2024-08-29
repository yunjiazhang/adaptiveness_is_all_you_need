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
  AND (mi1.info IN ('Documentary',
                    'Drama'))
  AND (kt.kind IN ('movie',
                   'tv movie'))
  AND (rt.role IN ('actress',
                   'miscellaneous crew'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (n.surname_pcode IN ('A45',
                           'B42',
                           'B6',
                           'B63',
                           'D12',
                           'D5',
                           'H62',
                           'R',
                           'R5',
                           'S23'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Fox Network',
                   'Independent Television (ITV)',
                   'Metro-Goldwyn-Mayer (MGM)',
                   'National Broadcasting Company (NBC)',
                   'Paramount Pictures',
                   'Shout! Factory',
                   'Sony Pictures Home Entertainment',
                   'Universal Pictures',
                   'Warner Bros'))
  AND (ct.kind IN ('distributors',
                   'production companies'))