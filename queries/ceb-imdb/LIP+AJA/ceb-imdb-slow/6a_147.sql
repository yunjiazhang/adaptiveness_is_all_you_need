SELECT COUNT(*)
FROM title AS t,
     movie_info AS mi1,
     kind_type AS kt,
     info_type AS it1,
     info_type AS it3,
     info_type AS it4,
     movie_info_idx AS mii1,
     movie_info_idx AS mii2,
     aka_name AS an,
     name AS n,
     info_type AS it5,
     person_info AS pi1,
     cast_info AS ci,
     role_type AS rt
WHERE t.id = mi1.movie_id
  AND t.id = ci.movie_id
  AND t.id = mii1.movie_id
  AND t.id = mii2.movie_id
  AND mii2.movie_id = mii1.movie_id
  AND mi1.movie_id = mii1.movie_id
  AND mi1.info_type_id = it1.id
  AND mii1.info_type_id = it3.id
  AND mii2.info_type_id = it4.id
  AND t.kind_id = kt.id
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (mi1.info IN ('Argentina:13',
                    'Argentina:Atp',
                    'Finland:K-16',
                    'Netherlands:12',
                    'Singapore:PG',
                    'Sweden:15',
                    'UK:15',
                    'UK:18',
                    'UK:PG',
                    'USA:Approved',
                    'USA:Not Rated',
                    'USA:Passed',
                    'USA:R',
                    'USA:TV-14'))
  AND (it1.id IN ('15',
                  '5'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 5.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 2.0 <= mii2.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 0.0 <= mii1.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii1.info::float <= 10000.0)
  AND n.id = ci.person_id
  AND ci.person_id = pi1.person_id
  AND it5.id = pi1.info_type_id
  AND n.id = pi1.person_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND an.person_id = pi1.person_id
  AND rt.id = ci.role_id
  AND (n.gender IN ('f')
       OR n.gender IS NULL)
  AND (n.name_pcode_nf IN ('A4253',
                           'A5354',
                           'C3654',
                           'C6231',
                           'G6252',
                           'J2152',
                           'J23',
                           'M2426',
                           'M6215',
                           'M6312',
                           'M6542',
                           'R2414',
                           'S1652',
                           'W5245'))
  AND (ci.note IN ('(writer)')
       OR ci.note IS NULL)
  AND (rt.role IN ('actress',
                   'editor',
                   'writer'))
  AND (it5.id IN ('26'))