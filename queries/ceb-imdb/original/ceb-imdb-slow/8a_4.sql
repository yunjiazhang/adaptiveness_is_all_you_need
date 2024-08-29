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
  AND (it1.id IN ('1'))
  AND (mi1.info IN ('30',
                    '60',
                    'USA:30',
                    'USA:60'))
  AND (kt.kind IN ('episode',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'producer',
                   'production designer',
                   'writer'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('B452',
                           'B635',
                           'B653',
                           'C42',
                           'C52',
                           'C63',
                           'G52',
                           'K5',
                           'K62',
                           'L6',
                           'M52',
                           'O2',
                           'R25')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('ABS-CBN',
                   'American Broadcasting Company (ABC)',
                   'British Broadcasting Corporation (BBC)',
                   'Columbia Broadcasting System (CBS)',
                   'National Broadcasting Company (NBC)',
                   'Warner Bros. Television'))
  AND (ct.kind IN ('distributors',
                   'production companies'))