SELECT COUNT(*)
FROM title AS t,
     movie_keyword AS mk,
     keyword AS k,
     movie_companies AS mc,
     company_name AS cn,
     company_type AS ct,
     kind_type AS kt,
     cast_info AS ci,
     name AS n,
     role_type AS rt
WHERE t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mk.movie_id = mc.movie_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND kt.id = t.kind_id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND t.production_year <= 2015
  AND 1975 < t.production_year
  AND k.keyword IN ('based-on-novel',
                    'character-name-in-title',
                    'death',
                    'female-frontal-nudity',
                    'independent-film',
                    'kidnapping',
                    'male-frontal-nudity',
                    'murder',
                    'sequel',
                    'singing',
                    'song')
  AND cn.country_code IN ('[ar]',
                          '[at]',
                          '[au]',
                          '[be]',
                          '[dk]',
                          '[gr]',
                          '[it]',
                          '[jp]',
                          '[nl]',
                          '[ph]',
                          '[se]')
  AND ct.kind IN ('distributors',
                  'production companies')
  AND kt.kind IN ('episode',
                  'movie',
                  'video movie')
  AND rt.role IN ('actor',
                  'cinematographer')
  AND n.gender IN ('m')