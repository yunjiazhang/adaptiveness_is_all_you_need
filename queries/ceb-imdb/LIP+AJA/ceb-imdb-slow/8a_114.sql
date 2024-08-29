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
  AND (mi1.info IN ('Color'))
  AND (kt.kind IN ('movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'writer'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('B4',
                           'B6',
                           'C462',
                           'D12',
                           'D25',
                           'G65',
                           'H65',
                           'J525',
                           'K5',
                           'P6',
                           'P62',
                           'R3',
                           'S5')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Fox Network',
                   'Independent Television (ITV)',
                   'Metro-Goldwyn-Mayer (MGM)',
                   'National Broadcasting Company (NBC)',
                   'Shout! Factory',
                   'Universal Pictures',
                   'Universal TV',
                   'Warner Bros'))
  AND (ct.kind IN ('distributors',
                   'production companies'))