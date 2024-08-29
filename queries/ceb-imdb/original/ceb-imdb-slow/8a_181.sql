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
  AND (mi1.info IN ('DTS',
                    'Dolby Digital',
                    'Dolby',
                    'Mono'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'director',
                   'producer'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (n.name_pcode_cf IN ('A5362',
                           'B4525',
                           'B6245',
                           'O4252',
                           'R363',
                           'S3152',
                           'W5165'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Metro-Goldwyn-Mayer (MGM)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))