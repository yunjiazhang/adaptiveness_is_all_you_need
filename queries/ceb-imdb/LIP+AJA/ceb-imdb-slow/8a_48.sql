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
  AND (it1.id IN ('5'))
  AND (mi1.info IN ('Argentina:16',
                    'Iceland:12',
                    'Italy:T',
                    'Singapore:M18'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('actor',
                   'producer',
                   'production designer'))
  AND (n.gender IN ('m'))
  AND (n.surname_pcode IN ('B42',
                           'B53',
                           'B626',
                           'B652',
                           'C462',
                           'F63',
                           'G635',
                           'H52',
                           'M324',
                           'N425',
                           'P2',
                           'P6',
                           'S52')
       OR n.surname_pcode IS NULL)
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1875)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Paramount Pictures',
                   'Pathé Frères',
                   'Universal Pictures',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))