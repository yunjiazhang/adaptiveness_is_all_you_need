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
AND (it1.id IN ('5'))
AND (mi1.info in ('Netherlands:12'))
AND (kt.kind in ('episode'))
AND (rt.role in ('actor','producer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('C6231','C6425','E3241','F6524','J5252','J5265','M2416','P3625','R1635','R2635','S3152'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (cn.name in ('British Broadcasting Corporation (BBC)','Columbia Broadcasting System (CBS)'))
AND (ct.kind in ('production companies'))
