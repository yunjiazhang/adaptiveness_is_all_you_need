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
  AND (it1.id IN ('4'))
  AND (mi1.info IN ('English',
                    'French'))
  AND (kt.kind IN ('movie',
                   'tv series',
                   'video movie'))
  AND (rt.role IN ('actor',
                   'editor'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('A45',
                           'B42',
                           'B452',
                           'C462',
                           'H62',
                           'H65',
                           'M5',
                           'P6',
                           'S23',
                           'S363',
                           'Y52')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Metro-Goldwyn-Mayer (MGM)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))