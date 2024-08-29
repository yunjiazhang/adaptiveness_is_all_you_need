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
  AND (it1.id IN ('7'))
  AND (mi1.info IN ('LAB:Technicolor',
                    'OFM:35 mm',
                    'PCS:Digital Intermediate',
                    'PCS:Kinescope',
                    'PFM:Video',
                    'RAT:1.37 : 1'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'tv series'))
  AND (rt.role IN ('actor',
                   'actress',
                   'miscellaneous crew'))
  AND (n.gender IN ('f',
                    'm'))
  AND (n.surname_pcode IN ('C636',
                           'H62',
                           'K4',
                           'K5',
                           'L535',
                           'M42',
                           'M624',
                           'N25',
                           'R32',
                           'T26',
                           'V2'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (cn.name IN ('20th Century Fox Television',
                   'ABS-CBN',
                   'American Broadcasting Company (ABC)',
                   'British Broadcasting Corporation (BBC)',
                   'Columbia Broadcasting System (CBS)',
                   'Granada Television',
                   'National Broadcasting Company (NBC)',
                   'Warner Bros. Television',
                   'Warner Home Video'))
  AND (ct.kind IN ('distributors',
                   'production companies'))