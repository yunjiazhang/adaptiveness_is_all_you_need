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
  AND (it1.id IN ('18'))
  AND (mi1.info IN ('New York City, New York, USA',
                    'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('actor'))
  AND (n.gender IN ('m'))
  AND (n.name_pcode_nf IN ('A4163',
                           'C6231',
                           'C6421',
                           'C6423',
                           'C6425',
                           'F6521',
                           'F6524',
                           'F6525',
                           'R1631',
                           'R1632',
                           'R2632')
       OR n.name_pcode_nf IS NULL)
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1875)
  AND (cn.name IN ('Metro-Goldwyn-Mayer (MGM)',
                   'Paramount Pictures',
                   'Universal Pictures',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors'))