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
  AND (it1.id IN ('5'))
  AND (it2.id IN ('3'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Argentina:13',
                    'Australia:G',
                    'Australia:M',
                    'Australia:PG',
                    'Belgium:KT',
                    'Finland:K-12',
                    'Finland:K-16',
                    'Sweden:15',
                    'UK:A',
                    'USA:Approved',
                    'USA:Not Rated',
                    'West Germany:16',
                    'West Germany:18'))
  AND (mi2.info IN ('Action',
                    'Adventure',
                    'Crime',
                    'Documentary',
                    'Drama',
                    'Romance',
                    'War'))
  AND (kt.kind IN ('movie'))
  AND (rt.role IN ('production designer'))
  AND (n.gender IN ('f'))
  AND (t.production_year <= 1975)
  AND (t.production_year >= 1925)