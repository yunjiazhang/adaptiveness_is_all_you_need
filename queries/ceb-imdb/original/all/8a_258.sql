SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('3'))
AND (mi1.info in ('Action','Comedy','Crime','Romance'))
AND (kt.kind in ('movie'))
AND (rt.role in ('actor','director','producer'))
AND (n.gender in ('f','m'))
AND (n.name_pcode_cf in ('A4361','B4525','B6261','B6526','J5252','S3152','S4153'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (cn.name in ('Columbia Broadcasting System (CBS)','Warner Home Video'))
AND (ct.kind in ('distributors'))
