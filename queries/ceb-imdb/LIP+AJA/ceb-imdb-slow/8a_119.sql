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
  AND (mi1.info IN ('CAM:Panavision Cameras and Lenses',
                    'LAB:Technicolor, Hollywood (CA), USA',
                    'PCS:Digital Intermediate',
                    'PCS:Kinescope',
                    'PCS:Panavision',
                    'PFM:35 mm',
                    'RAT:1.33 : 1',
                    'RAT:16:9 HD'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'miscellaneous crew'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('B5',
                           'B626',
                           'C5',
                           'D4',
                           'H2',
                           'K5',
                           'L',
                           'L2',
                           'M2',
                           'M62',
                           'P62',
                           'S415',
                           'S5',
                           'W42')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))