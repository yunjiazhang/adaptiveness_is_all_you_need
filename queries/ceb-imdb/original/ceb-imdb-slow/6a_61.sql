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
  AND (mi1.info IN ('Animation',
                    'Comedy',
                    'Crime',
                    'Drama',
                    'Horror',
                    'Romance',
                    'Short',
                    'Thriller'))
  AND (it1.id IN ('13',
                  '3'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 11.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 7.0 <= mii2.info::float)
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
  AND (n.gender IN ('f'))
  AND (n.name_pcode_nf IN ('A4253',
                           'A5216',
                           'A5263',
                           'A5264',
                           'B6164',
                           'F6523',
                           'G1642',
                           'J5162',
                           'K3652',
                           'M6243',
                           'M6254',
                           'M6523',
                           'S1524',
                           'T6252'))
  AND (ci.note IS NULL)
  AND (rt.role IN ('actress'))
  AND (it5.id IN ('37'))