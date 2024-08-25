SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('18'))
AND (it2.id in ('7'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('CBS Studio 50, New York City, New York, USA','Iverson Ranch - 1 Iverson Lane, Chatsworth, Los Angeles, California, USA','Mexico','Paris, France'))
AND (mi2.info in ('OFM:35 mm','PCS:Spherical','PFM:35 mm','RAT:1.33 : 1'))
AND (kt.kind in ('episode','movie','tv movie'))
AND (rt.role in ('costume designer'))
AND (n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (k.keyword IN ('annoying-person','blind-date','brown-derby','clap-the-disease','crack-in-ozone-layer','cultural-bias','death-by-hanging','deserted-road','epigenetics','falsely-believing-self-to-be-killer','meatpacking','mono-opera','orphaned-girl','reference-to-charles-grodan','reference-to-james-cagney','reference-to-michael-beck','same-actor-playing-two-characters-simultaneously-on-screen','schizo','tail-as-crank','teleiophile','worried-father'))
