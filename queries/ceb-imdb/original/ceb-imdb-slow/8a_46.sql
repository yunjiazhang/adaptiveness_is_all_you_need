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
  AND (it1.id IN ('6'))
  AND (mi1.info IN ('Dolby Digital',
                    'Dolby',
                    'Mono',
                    'Stereo'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('director',
                   'miscellaneous crew',
                   'producer'))
  AND (n.gender IS NULL)
  AND (n.surname_pcode IN ('B4',
                           'B6',
                           'B624',
                           'C5',
                           'D12',
                           'D5',
                           'G65',
                           'K5',
                           'L',
                           'L2',
                           'L52',
                           'M2',
                           'W3'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Fox Network',
                   'Independent Television (ITV)',
                   'National Broadcasting Company (NBC)',
                   'Paramount Pictures',
                   'Shout! Factory',
                   'Sony Pictures Home Entertainment',
                   'Universal Pictures',
                   'Universal TV',
                   'Warner Bros'))
  AND (ct.kind IN ('distributors',
                   'production companies'))