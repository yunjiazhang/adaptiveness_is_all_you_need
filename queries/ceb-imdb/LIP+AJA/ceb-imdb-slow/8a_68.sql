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
  AND (mi1.info IN ('SDDS',
                    'Stereo'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'director'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.name_pcode_nf IN ('C6231',
                           'D5162',
                           'F6524',
                           'F6525',
                           'J5215',
                           'P436',
                           'R1635',
                           'R2632',
                           'R2635',
                           'S3152'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors'))