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
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (mi1.info IN ('Buenos Aires, Federal District, Argentina',
                    'Los Angeles, California, USA',
                    'Mexico',
                    'New York City, New York, USA',
                    'Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA'))
  AND (it1.id IN ('18'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 7.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 3.0 <= mii2.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 0.0 <= mii1.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii1.info::float <= 10000.0)
  AND n.id = ci.person_id
  AND ci.person_id = pi1.person_id
  AND it5.id = pi1.info_type_id
  AND n.id = pi1.person_id
  AND n.id = an.person_id
  AND rt.id = ci.role_id
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (n.name_pcode_nf IN ('D2313',
                           'E3261',
                           'G625',
                           'J5141',
                           'K1524',
                           'L2125',
                           'M2563',
                           'M265',
                           'M3215',
                           'P3625',
                           'S5326',
                           'S6256',
                           'T5252'))
  AND (ci.note IN ('(writer)')
       OR ci.note IS NULL)
  AND (rt.role IN ('actor',
                   'director',
                   'writer'))
  AND (it5.id IN ('31'))