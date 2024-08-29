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
  AND (mi1.info IN ('Mono',
                    'Stereo'))
  AND (kt.kind IN ('episode',
                   'tv movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'director',
                   'producer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.name_pcode_cf IN ('A4361',
                           'A5362',
                           'B6525',
                           'B6526',
                           'C6325',
                           'G6262',
                           'J5256',
                           'M6256',
                           'P3625',
                           'P6252',
                           'R1525',
                           'R2632',
                           'S4153',
                           'W4525'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'Columbia Broadcasting System (CBS)',
                   'National Broadcasting Company (NBC)'))
  AND (ct.kind IN ('distributors'))