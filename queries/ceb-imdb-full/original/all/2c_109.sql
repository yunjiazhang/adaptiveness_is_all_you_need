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
AND (it2.id in ('17'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Black and White','Color'))
AND (mi2.info IN ('Last show of the series.','One of over 700 Paramount Productions, filmed between 1929 and 1949, which were sold to MCA/Universal in 1958 for television distribution, and have been owned and controlled by Universal ever since.','Original French title is undetermined.'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('actor','actress','costume designer','miscellaneous crew','production designer'))
AND (n.gender IN ('m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (t.title in ('(#1.107)','(#2.36)','(#2.7)','(#3.6)','Among Those Present','Another Thin Man','Betrayed','Crossfire','Devils Island','Eyewitness','Happy Days','His Brothers Keeper','Lost and Found','Meet John Doe','Million Dollar Mermaid','Only Yesterday','Scandal Sheet','Somebody Up There Likes Me','Stowaway','Thats the Spirit','The Country Doctor','The Fugitives','The Gamble','The Gambler','The Great Train Robbery','The Kid from Texas','The Lost City','The Visitor','Tom Sawyer','Tommy','Uncle Toms Cabin','Vice Versa'))
