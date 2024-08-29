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
  AND (it1.id IN ('2'))
  AND (it2.id IN ('4'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Black and White',
                    'Color'))
  AND (mi2.info IN ('Cantonese',
                    'Czech',
                    'English',
                    'Finnish',
                    'French',
                    'German',
                    'Hebrew',
                    'Hindi',
                    'Italian',
                    'Polish',
                    'Portuguese',
                    'Serbo-Croatian',
                    'Spanish'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('cinematographer',
                   'production designer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (t.production_year <= 2010)
  AND (t.production_year >= 1950)
  AND (k.keyword IN ('bare-breasts',
                     'character-name-in-title',
                     'death',
                     'female-frontal-nudity',
                     'female-nudity',
                     'gay',
                     'hospital',
                     'independent-film',
                     'lesbian',
                     'lesbian-sex',
                     'mother-daughter-relationship',
                     'new-york-city',
                     'nudity',
                     'party',
                     'singer',
                     'singing'))