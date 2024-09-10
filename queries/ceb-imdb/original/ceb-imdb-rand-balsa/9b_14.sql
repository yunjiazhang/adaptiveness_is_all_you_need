SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('12','94'))
AND (it2.id IN ('24'))
AND (mi1.info IN ('At the end of the closing credits of episode, Alf is heard laughing.','The Avengers who appear in the screen just before the series logo vary along with who will be in the chapter. If only Thor is going be in it, only Thor is seen.','There are no opening credits after the title is shown.','There are no opening credits.','When the title "Frasier" and the usual silhouette of Seattle are on screen, a lightning bolt flashes in the sky.','When the title "Frasier" and the usual silhouette of Seattle are on screen, a red light blinks at the highest point of the Space Needle.','When the title "Frasier" and the usual silhouette of Seattle are on screen, fireworks shoot to the sky.','When the title "Frasier" and the usual silhouette of Seattle are on screen, several lights are being lit in the "windows" of the buildings.'))
AND (n.name ILIKE '%av%')
AND (kt.kind IN ('episode','movie','video movie'))
AND (rt.role IN ('cinematographer','composer','editor','production designer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
GROUP BY mi1.info, n.name