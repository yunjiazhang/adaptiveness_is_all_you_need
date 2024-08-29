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
  AND (it1.id IN ('18'))
  AND (it2.id IN ('2'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Baltimore, Maryland, USA',
                    'Budapest, Hungary',
                    'Burbank, California, USA',
                    'Cologne, North Rhine - Westphalia, Germany',
                    'Florida, USA',
                    'New Jersey, USA',
                    'Orlando, Florida, USA',
                    'Spain',
                    'Stage 10, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA',
                    'Stage 25, Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA',
                    'Vienna, Austria',
                    'Winnipeg, Manitoba, Canada'))
  AND (mi2.info IN ('Color'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('cinematographer',
                   'production designer'))
  AND (n.gender IN ('f',
                    'm'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (k.keyword IN ('anal-sex',
                     'based-on-play',
                     'doctor',
                     'dog',
                     'father-son-relationship',
                     'female-nudity',
                     'husband-wife-relationship',
                     'interview',
                     'jealousy',
                     'lesbian-sex',
                     'love',
                     'marriage',
                     'murder',
                     'nudity',
                     'sequel',
                     'surrealism',
                     'tv-mini-series',
                     'violence'))