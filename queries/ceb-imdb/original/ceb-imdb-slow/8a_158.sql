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
  AND (it1.id IN ('18'))
  AND (mi1.info IN ('CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA',
                    'General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA',
                    'Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA',
                    'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA',
                    'Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA',
                    'Revue Studios, Hollywood, Los Angeles, California, USA',
                    'Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('director',
                   'miscellaneous crew'))
  AND (n.gender IS NULL)
  AND (n.name_pcode_nf IN ('C6231',
                           'C6235',
                           'J5162',
                           'K6235',
                           'M6216',
                           'R1632'))
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
                   'Universal TV',
                   'Warner Bros'))
  AND (ct.kind IN ('distributors',
                   'production companies'))