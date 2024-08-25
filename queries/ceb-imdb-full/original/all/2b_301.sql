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
AND (it1.id in ('4'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Cantonese','Danish','French','Hindi','Italian','Japanese','Norwegian','Polish','Romanian','Serbo-Croatian','Spanish'))
AND (mi2.info in ('Comedy','Crime','Documentary','Drama','History','Horror','Music','Mystery','Short','Thriller','Western'))
AND (kt.kind in ('tv movie','video game'))
AND (rt.role in ('editor'))
AND (n.gender in ('f'))
AND (t.production_year <= 2010)
AND (t.production_year >= 1950)
AND (k.keyword IN ('anal-sex','character-name-in-title','female-frontal-nudity','gay','independent-film','interview','surrealism'))
