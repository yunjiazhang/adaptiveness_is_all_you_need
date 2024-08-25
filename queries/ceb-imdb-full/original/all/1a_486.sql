SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('18'))
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('CBS Studio Center - 4024 Radford Avenue, Studio City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA','Madrid, Spain','Mexico','Paris, France','Philippines','Pinewood Studios, Iver Heath, Buckinghamshire, England, UK','Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA','Shepperton Studios, Shepperton, Surrey, England, UK','Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA'))
AND (mi2.info IN ('Argentina','Austria','Czechoslovakia','Finland','France','Germany','India','Italy','Poland','Portugal','Soviet Union','Sweden','UK','West Germany'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game'))
AND (rt.role in ('composer','editor','writer'))
AND (n.gender IN ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
