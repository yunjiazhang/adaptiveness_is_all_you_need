SELECT COUNT(*)
FROM title AS t,
     kind_type AS kt,
     info_type AS it1,
     movie_info AS mi1,
     movie_info AS mi2,
     info_type AS it2,
     cast_info AS ci,
     role_type AS rt,
     name AS n,
     movie_keyword AS mk,
     keyword AS k
WHERE t.id = ci.movie_id
  AND t.id = mi1.movie_id
  AND t.id = mi2.movie_id
  AND t.id = mk.movie_id
  AND k.id = mk.keyword_id
  AND mi1.movie_id = mi2.movie_id
  AND mi1.info_type_id = it1.id
  AND mi2.info_type_id = it2.id
  AND (it1.id IN ('7'))
  AND (it2.id IN ('2'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('OFM:35 mm',
                    'OFM:Digital',
                    'PCS:Spherical',
                    'PFM:D-Cinema',
                    'PFM:Digital',
                    'RAT:1.33 : 1',
                    'RAT:1.37 : 1'))
  AND (mi2.info IN ('Black and White',
                    'Color'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('producer'))
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1990)