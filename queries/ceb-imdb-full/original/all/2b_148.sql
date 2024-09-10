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
AND (it1.id in ('2'))
AND (it2.id in ('16'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Color'))
AND (mi2.info in ('USA:2002','USA:2003','USA:2005','USA:2006','USA:2007','USA:2008','USA:2009','USA:2010','USA:2011','USA:2012'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('composer'))
AND (n.gender in ('m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (k.keyword IN ('bare-chested-male','based-on-play','cigarette-smoking','dancing','doctor','family-relationships','female-nudity','fight','friendship','independent-film','jealousy','male-frontal-nudity','mother-son-relationship','singing'))