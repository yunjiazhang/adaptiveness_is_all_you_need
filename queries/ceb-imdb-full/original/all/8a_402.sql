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
AND (it1.id IN ('18'))
AND (mi1.info in ('CBS Studio 50, New York City, New York, USA','CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Los Angeles, California, USA','Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA'))
AND (kt.kind in ('episode','movie'))
AND (rt.role in ('actor','director'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_cf in ('A4361','B4525','B6526','J5252','R1632','S4153','S5362'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (cn.name in ('Columbia Broadcasting System (CBS)','Warner Home Video'))
AND (ct.kind in ('distributors','production companies'))
