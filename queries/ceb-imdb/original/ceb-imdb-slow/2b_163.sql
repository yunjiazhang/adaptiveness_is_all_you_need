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
  AND (it2.id IN ('18'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Comedy',
                    'Crime',
                    'Documentary',
                    'Drama',
                    'Fantasy',
                    'Mystery',
                    'Short',
                    'Thriller'))
  AND (mi2.info IN ('Austin, Texas, USA',
                    'Berlin, Germany',
                    'Brooklyn, New York City, New York, USA',
                    'Chicago, Illinois, USA',
                    'London, England, UK',
                    'Los Angeles, California, USA',
                    'Madrid, Spain',
                    'New York City, New York, USA',
                    'San Francisco, California, USA',
                    'Sydney, New South Wales, Australia',
                    'Washington, District of Columbia, USA'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('editor'))
  AND (n.gender IN ('f'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (k.keyword IN ('bare-breasts',
                     'bare-chested-male',
                     'based-on-novel',
                     'character-name-in-title',
                     'dancing',
                     'death',
                     'female-nudity',
                     'lesbian-sex',
                     'male-frontal-nudity',
                     'marriage',
                     'mother-daughter-relationship',
                     'new-york-city',
                     'nudity',
                     'number-in-title',
                     'one-word-title',
                     'oral-sex',
                     'sequel',
                     'singing',
                     'suicide',
                     'surrealism'))