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
  AND (mi1.info IN ('Canada:13+',
                    'Canada:14A',
                    'Finland:K-12',
                    'Germany:16',
                    'Netherlands:12',
                    'Netherlands:16',
                    'Netherlands:AL',
                    'Singapore:M18',
                    'South Korea:15',
                    'South Korea:18',
                    'Spain:18',
                    'Sweden:11',
                    'UK:18',
                    'UK:A',
                    'USA:TV-G'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('actor',
                   'actress',
                   'miscellaneous crew',
                   'producer'))
  AND (n.gender IN ('f',
                    'm')
       OR n.gender IS NULL)
  AND (n.name_pcode_nf IN ('A5352',
                           'B6161',
                           'C6231',
                           'C6235',
                           'E3632',
                           'G6252',
                           'J5216',
                           'J5235',
                           'M2425',
                           'R1632',
                           'S3152'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('Columbia Broadcasting System (CBS)',
                   'Metro-Goldwyn-Mayer (MGM)',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))