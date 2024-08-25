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
AND (n.name_pcode_nf in ('D5132','D5362','F6324','J262','J5141','J5163','J53','R1632','R1634','R412','R4126'))
AND (ci.note in ('(co-executive producer)','(producer)','(production assistant)','(sales representative)','(supervising producer)','(technical supervisor)','(writer)') OR ci.note IS NULL)
AND (rt.role in ('costume designer','miscellaneous crew','producer','production designer','writer'))
AND (it1.id in ('22'))
