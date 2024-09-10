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
     keyword AS k
WHERE t.id = mi1.movie_id
  AND t.id = mii1.movie_id
  AND t.id = mii2.movie_id
  AND t.id = mk.movie_id
  AND mii2.movie_id = mii1.movie_id
  AND mi1.movie_id = mii1.movie_id
  AND mk.movie_id = mi1.movie_id
  AND mk.keyword_id = k.id
  AND mi1.info_type_id = it1.id
  AND mii1.info_type_id = it3.id
  AND mii2.info_type_id = it4.id
  AND t.kind_id = kt.id
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (mi1.info IN ('Dolby',
                    'English',
                    'French',
                    'German',
                    'Japanese',
                    'Mono',
                    'Portuguese',
                    'Silent',
                    'Stereo'))
  AND (it1.id IN ('4',
                  '6'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 11.0)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 7.0 <= mii2.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 0.0 <= mii1.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii1.info::float <= 500.0)