SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (mi1.info IN ('New York City, New York, USA','Paramount Studios - 5555 Melrose Avenue, Hollywood, Los Angeles, California, USA'))
AND (it1.id IN ('18','9'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f','m'))
AND (n.name_pcode_nf in ('A4236','A4253','A5361','B6165','F6524','J5163','J5214','M6216','S3541','V2362'))
AND (ci.note in ('(voice)') OR ci.note IS NULL)
AND (rt.role in ('actor','actress'))
AND (it5.id in ('22'))
