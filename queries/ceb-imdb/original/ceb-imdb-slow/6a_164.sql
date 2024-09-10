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
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (mi1.info IN ('New York City, New York, USA',
                    'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA'))
  AND (it1.id IN ('103',
                  '18',
                  '98'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 8.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 0.0 <= mii2.info::float)
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
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (n.name_pcode_nf IN ('A6362',
                           'D5216',
                           'D5432',
                           'E3631',
                           'F6524',
                           'G6253',
                           'J5163',
                           'J5214',
                           'L2142',
                           'P3652',
                           'V2361'))
  AND (ci.note IN ('(voice)')
       OR ci.note IS NULL)
  AND (rt.role IN ('actor'))
  AND (it5.id IN ('22'))