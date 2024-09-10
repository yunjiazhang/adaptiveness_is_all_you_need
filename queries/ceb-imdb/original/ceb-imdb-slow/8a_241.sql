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
  AND (mi1.info IN ('Adventure',
                    'Animation',
                    'Documentary',
                    'Drama',
                    'Family',
                    'Mystery'))
  AND (kt.kind IN ('movie',
                   'tv movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'miscellaneous crew'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (n.name_pcode_nf IN ('C6235',
                           'M4145',
                           'P3625',
                           'R1635',
                           'R2631',
                           'S3152'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)
  AND (cn.name IN ('British Broadcasting Corporation (BBC)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors'))