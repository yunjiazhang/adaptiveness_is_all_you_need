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
  AND (mi1.info IN ('Comedy',
                    'Drama'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('miscellaneous crew'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (n.name_pcode_cf IN ('A3654',
                           'B4353',
                           'C6264',
                           'D2362',
                           'D4262',
                           'F6532',
                           'L1561',
                           'M5323',
                           'N2426',
                           'R2461',
                           'S4362'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (cn.name IN ('ABS-CBN',
                   'Fox Network',
                   'Granada Television',
                   'Sony Pictures Home Entertainment',
                   'Warner Bros. Television'))
  AND (ct.kind IN ('distributors',
                   'production companies'))