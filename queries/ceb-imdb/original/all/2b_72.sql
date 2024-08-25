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
AND (it1.id in ('7'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('MET:15.2 m','MET:600 m','OFM:16 mm','OFM:68 mm','PFM:35 mm','PFM:68 mm','RAT:1.33 : 1','RAT:1.36 : 1','RAT:1.37 : 1','RAT:1.85 : 1'))
AND (mi2.info in ('Documentary','Drama','Family','Fantasy','History','Short','Sport','Western'))
AND (kt.kind in ('episode','movie','tv movie'))
AND (rt.role in ('composer'))
AND (n.gender in ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (k.keyword IN ('abbasid-dynasty','canisius-college','child-bride','daniel-barenboim-orchestra','dress-making','edo-period','groupie','hiding-in-pile-of-naked-corpses','hispaniola','leaf-blower','meaninglessness','musical-instrument-tuner','police-hunt','ravendactyl','reference-to-mount-rushmore','removing-fingernail','spilled-ketchup','uno-floag','unusual-opening-credits','wired-witness','yellow-hair'))
