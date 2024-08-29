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
  AND (mi1.info IN ('English',
                    'French',
                    'German',
                    'Japanese',
                    'OFM:Video',
                    'PFM:35 mm',
                    'RAT:1.33 : 1',
                    'RAT:1.37 : 1',
                    'RAT:1.78 : 1',
                    'RAT:16:9 HD',
                    'Spanish'))
  AND (it1.id IN ('17',
                  '4',
                  '7'))
  AND it3.id = '100'
  AND it4.id = '101'
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii2.info::float <= 8.3)
  AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 5.5 <= mii2.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND 10000.0 <= mii1.info::float)
  AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$'
       AND mii1.info::float <= 20000.0)