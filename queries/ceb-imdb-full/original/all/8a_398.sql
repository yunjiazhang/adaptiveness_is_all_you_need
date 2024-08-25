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
AND (it1.id IN ('7'))
AND (mi1.info in ('CAM:Panavision Cameras and Lenses','MET:300 m','MET:600 m','OFM:35 mm','PCS:Super 35','PFM:35 mm','RAT:1.20 : 1','RAT:1.78 : 1'))
AND (kt.kind in ('episode','movie'))
AND (rt.role in ('actor'))
AND (n.gender in ('m'))
AND (n.name_pcode_cf in ('A5362'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (cn.name in ('Paramount Pictures','Pathé Frères','Universal Pictures','Warner Home Video'))
AND (ct.kind in ('distributors','production companies'))
