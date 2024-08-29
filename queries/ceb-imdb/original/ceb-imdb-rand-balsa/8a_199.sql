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
AND (it1.id IN ('4'))
AND (mi1.info in ('English'))
AND (kt.kind in ('tv movie','tv series'))
AND (rt.role in ('composer','editor','miscellaneous crew','producer'))
AND (n.gender IS NULL)
AND (n.name_pcode_cf in ('A2365','A6252','D1614','E1524','L1214','L2','M3425','M6352','P5215','Q5325','R2425','R3626','S5325','V4626'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (cn.name in ('20th Century Fox Television','ABS-CBN','British Broadcasting Corporation (BBC)','Columbia Broadcasting System (CBS)','Granada Television','National Broadcasting Company (NBC)','Warner Home Video'))
AND (ct.kind in ('distributors','production companies'))
