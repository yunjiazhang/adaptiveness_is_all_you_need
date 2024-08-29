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
  AND (it2.id IN ('7'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Color'))
  AND (mi2.info IN ('LAB:Consolidated Film Industries (CFI), Hollywood (CA), USA',
                    'LAB:DeLuxe',
                    'OFM:35 mm',
                    'RAT:16:9 HD'))
  AND (kt.kind IN ('episode',
                   'movie',
                   'video movie'))
  AND (rt.role IN ('cinematographer'))
  AND (n.gender IN ('m'))
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1975)
  AND (k.keyword IN ('bare-breasts',
                     'bare-chested-male',
                     'based-on-novel',
                     'based-on-play',
                     'death',
                     'family-relationships',
                     'female-nudity',
                     'gay',
                     'hardcore',
                     'homosexual',
                     'husband-wife-relationship',
                     'mother-son-relationship',
                     'non-fiction',
                     'nudity',
                     'oral-sex',
                     'police',
                     'revenge',
                     'sex',
                     'surrealism',
                     'violence'))