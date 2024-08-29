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
  AND (mi1.info IN ('Argentina:13',
                    'Australia:M',
                    'Australia:PG',
                    'Canada:G',
                    'Germany:12',
                    'Norway:15',
                    'Sweden:15',
                    'UK:15'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'producer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.name_pcode_cf IN ('B6261',
                           'D1232',
                           'O4252',
                           'P5235',
                           'S3152',
                           'W5165'))
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (cn.name IN ('British Broadcasting Corporation (BBC)',
                   'Columbia Broadcasting System (CBS)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))