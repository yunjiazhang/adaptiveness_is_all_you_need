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
  AND (it1.id IN ('3'))
  AND (it2.id IN ('5'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Adult',
                    'Comedy',
                    'Crime',
                    'Drama',
                    'Horror',
                    'Romance',
                    'Thriller'))
  AND (mi2.info IN ('Hong Kong:IIB',
                    'Netherlands:12',
                    'Netherlands:AL',
                    'Singapore:PG',
                    'UK:15',
                    'UK:PG',
                    'UK:R18',
                    'UK:U',
                    'USA:Not Rated',
                    'USA:Passed',
                    'USA:R'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('cinematographer',
                   'writer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)