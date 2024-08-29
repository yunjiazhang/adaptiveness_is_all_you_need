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
  AND (it2.id IN ('5'))
  AND t.kind_id = kt.id
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
  AND (mi1.info IN ('Black and White',
                    'Color'))
  AND (mi2.info IN ('Argentina:13',
                    'Australia:G',
                    'Finland:K-15',
                    'Iceland:16',
                    'Singapore:M18',
                    'Singapore:NC-16',
                    'South Korea:18',
                    'UK:12',
                    'USA:R',
                    'West Germany:12',
                    'West Germany:16',
                    'West Germany:18'))
  AND (kt.kind IN ('episode',
                   'movie'))
  AND (rt.role IN ('director'))
  AND (n.gender IN ('m')
       OR n.gender IS NULL)
  AND (t.production_year <= 2015)
  AND (t.production_year >= 1925)
  AND (k.keyword IN ('bare-chested-male',
                     'based-on-play',
                     'character-name-in-title',
                     'dancing',
                     'death',
                     'gay',
                     'homosexual',
                     'lesbian-sex',
                     'love',
                     'murder',
                     'non-fiction',
                     'oral-sex',
                     'song',
                     'suicide',
                     'violence'))