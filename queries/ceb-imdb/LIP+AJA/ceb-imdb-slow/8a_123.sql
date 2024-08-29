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
  AND (kt.kind IN ('episode'))
  AND (rt.role IN ('actor',
                   'actress',
                   'director'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.name_pcode_nf IN ('A4163',
                           'C6426',
                           'D1316',
                           'D5216',
                           'G6216',
                           'G6252',
                           'J525',
                           'M6263',
                           'P3616',
                           'P3624',
                           'P436',
                           'W4525'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'Columbia Broadcasting System (CBS)',
                   'National Broadcasting Company (NBC)'))
  AND (ct.kind IN ('distributors'))