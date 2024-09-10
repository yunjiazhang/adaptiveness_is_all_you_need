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
  AND (it1.id IN ('2'))
  AND (mi1.info IN ('Black and White',
                    'Color'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'director'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.name_pcode_nf IN ('A4163',
                           'B6161',
                           'C6423',
                           'C6424',
                           'E3241',
                           'F6525',
                           'G6252',
                           'J52',
                           'J5265',
                           'K3451',
                           'M2425',
                           'M6263',
                           'P436',
                           'R1634',
                           'W4516'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1875)
  AND (cn.name IN ('American Broadcasting Company (ABC)',
                   'Columbia Broadcasting System (CBS)',
                   'General Film Company'))
  AND (ct.kind IN ('distributors'))