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
  AND (kt.kind IN ('movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'director',
                   'production designer'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('A436',
                           'B635',
                           'C16',
                           'C45',
                           'C65',
                           'F63',
                           'F652',
                           'G6',
                           'K4',
                           'K52',
                           'M324',
                           'P4',
                           'P6',
                           'W425')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (cn.name IN ('British Broadcasting Corporation (BBC)',
                   'Columbia Broadcasting System (CBS)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))