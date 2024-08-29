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
  AND (it1.id IN ('5'))
  AND (it2.id IN ('4'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Australia:M',
                    'Finland:K-18',
                    'Germany:12',
                    'Germany:18',
                    'Iceland:12',
                    'Iceland:L',
                    'Netherlands:6',
                    'Norway:15',
                    'Spain:T',
                    'Sweden:11',
                    'Sweden:Btl',
                    'UK:12'))
  AND (mi2.info IN ('English',
                    'German'))
  AND (kt.kind IN ('tv movie',
                   'tv series',
                   'video game'))
  AND (rt.role IN ('miscellaneous crew',
                   'producer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (t.production_year <= 2010)
  AND (t.production_year >= 1950)
  AND (k.keyword IN ('cigarette-smoking',
                     'death',
                     'father-son-relationship',
                     'female-nudity',
                     'flashback',
                     'gay',
                     'gun',
                     'kidnapping',
                     'lesbian',
                     'male-nudity',
                     'mother-daughter-relationship',
                     'murder',
                     'new-york-city',
                     'nudity',
                     'number-in-title',
                     'one-word-title',
                     'oral-sex',
                     'sequel',
                     'singing',
                     'violence'))