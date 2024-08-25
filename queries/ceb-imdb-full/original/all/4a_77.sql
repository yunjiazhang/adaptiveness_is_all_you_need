SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender IS NULL)
AND (n.name_pcode_nf in ('A4163','A4253','A5352','A5362','C6231','C6235','F6521','M2423','P3623','S3152'))
AND (ci.note in ('(executive producer)','(producer)','(production assistant)') OR ci.note IS NULL)
AND (rt.role in ('cinematographer','composer','director','editor','miscellaneous crew','producer','writer'))
AND (it1.id in ('37'))
