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
  AND (mi1.info IN ('OFM:35 mm',
                    'PFM:35 mm',
                    'RAT:1.33 : 1',
                    'RAT:1.78 : 1',
                    'RAT:16:9 HD'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'composer',
                   'editor',
                   'miscellaneous crew',
                   'producer'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (n.name_pcode_cf IN ('A2365',
                           'A6252',
                           'C52',
                           'C6325',
                           'E1524',
                           'J5252',
                           'P6235',
                           'Q5325',
                           'R1632',
                           'R2425',
                           'R25',
                           'R3626',
                           'V4524',
                           'V4626'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('ABS-CBN',
                   'British Broadcasting Corporation (BBC)',
                   'Granada Television',
                   'National Broadcasting Company (NBC)'))
  AND (ct.kind IN ('distributors',
                   'production companies'))