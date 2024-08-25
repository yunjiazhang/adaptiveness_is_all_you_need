SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (k.keyword IN ('anxiety-attack','cowboy-costume','hospitalized','murder-of-mother-by-son','new-york-public-library','passing-note','st.-denis-france','steam-hut','year-508'))
AND (cn.country_code IN ('[ar]','[br]','[ch]','[fr]','[gb]','[kr]','[tr]','[us]'))
AND (ct.kind IN ('distributors','production companies'))
AND (kt.kind IN ('episode','movie','video movie'))
AND (rt.role IN ('editor','production designer'))
AND (n.gender IN ('f','m'))
