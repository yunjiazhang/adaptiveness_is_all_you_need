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
                    'Mono',
                    'Stereo'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie'))
  AND (rt.role IN ('miscellaneous crew',
                   'writer'))
  AND (n.gender IS NULL)
  AND (n.name_pcode_nf IN ('A5362',
                           'K6235',
                           'M6263',
                           'R1632',
                           'R2632')
       OR n.name_pcode_nf IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'British Broadcasting Corporation (BBC)',
                   'Columbia Broadcasting System (CBS)',
                   'National Broadcasting Company (NBC)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))