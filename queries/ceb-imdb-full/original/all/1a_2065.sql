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
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Bavaria Filmstudios, Geiselgasteig, Grünwald, Bavaria, Germany','Cinecittà Studios, Cinecittà, Rome, Lazio, Italy','Helsinki, Finland','Manhattan, New York City, New York, USA','New York City, New York, USA','Paris, France','Prague, Czech Republic','Republic Studios, Hollywood, Los Angeles, California, USA','Rome, Lazio, Italy'))
AND (mi2.info IN ('Action','Documentary','Drama','Family','Film-Noir','History','Romance','Sci-Fi','Thriller','War'))
AND (kt.kind in ('movie','tv movie','tv series','video movie'))
AND (rt.role in ('actress','costume designer'))
AND (n.gender IN ('f','m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
