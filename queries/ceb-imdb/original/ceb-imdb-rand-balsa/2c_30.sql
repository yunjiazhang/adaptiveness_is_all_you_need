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
AND (it1.id in ('2'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Black and White','Color'))
AND (mi2.info IN ('Adventure','Animation','Drama','Family','Fantasy','Game-Show','Horror','Music','Mystery','Romance','Short','Sport','War','Western'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video movie'))
AND (rt.role in ('actress','composer','director','miscellaneous crew','producer'))
AND (n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (t.title in ('(#3.21)','(#4.15)','A Family Affair','A Guy Named Joe','Act of Violence','Dick Tracy Returns','Die Falle','Easy Money','Fury','Jeder stirbt für sich allein','Lifeline','Lilith','Moving On','Protest','Shakedown','Shell Game','Six Bridges to Cross','South Pacific','Stakeout','The Accident','The Foxes of Harrow','The Gold Rush','The Magic Box','The Public Menace','The Racket','The Rainmaker','The Reunion','The Secret Storm','The Siege','The Switch','Untamed','Violence','War and Peace'))