SELECT COUNT(*)
FROM title AS t,
     movie_info AS mi1,
     kind_type AS kt,
     info_type AS it1,
     info_type AS it3,
     info_type AS it4,
     movie_info_idx AS mii1,
     movie_info_idx AS mii2,
     movie_keyword AS mk,
     keyword AS k,
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
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mi1.info_type_id = it1.id
  AND mii1.info_type_id = it3.id
  AND mii2.info_type_id = it4.id
  AND t.kind_id = kt.id
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (t.production_year <= 1990)
  AND (t.production_year >= 1950)
  AND (mi1.info IN ('Australia',
                    'Canada',
                    'Hong Kong',
                    'Mexico',
                    'Philippines',
                    'Soviet Union',
                    'Spain',
                    'Turkey'))
  AND (it1.id IN ('16',
                  '2',
                  '8'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 11.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 7.0 <= mii2.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 1000.0 <= mii1.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii1.info::float <= 10000.0)
  AND n.id = ci.person_id
  AND ci.person_id = pi1.person_id
  AND it5.id = pi1.info_type_id
  AND n.id = pi1.person_id
  AND n.id = an.person_id
  AND rt.id = ci.role_id
  AND (n.gender IN ('m'))
  AND (n.name_pcode_nf IN ('A5352',
                           'A5362',
                           'B1626',
                           'B6563',
                           'C6231',
                           'C6425',
                           'C6426',
                           'D1316',
                           'D1325',
                           'E6523',
                           'F6524',
                           'J5262',
                           'M2452',
                           'W4362')
       OR n.name_pcode_nf IS NULL)
  AND (ci.note IS NULL)
  AND (rt.role IN ('actor'))
  AND (it5.id IN ('34'))