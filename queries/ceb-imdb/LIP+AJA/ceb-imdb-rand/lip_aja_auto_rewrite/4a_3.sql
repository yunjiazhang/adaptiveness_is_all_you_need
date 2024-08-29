SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, n.id)), sum(pg_lip_bloom_add(1, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND ((n.name_pcode_nf)::text = ANY ('{A4524,E3632,G1641,G6212,J236,J265,J5213,J5215,J5254,J5635,M6265,N2421,N2423,P3632,W4524}'::text[]))) AND (((n.gender)::text = 'm'::text) AND ((n.name_pcode_nf)::text = ANY ('{A4524,E3632,G1641,G6212,J236,J265,J5213,J5215,J5254,J5635,M6265,N2421,N2423,P3632,W4524}'::text[])));


/*+
HashJoin(pi1 an n ci rt it1)
HashJoin(pi1 an n ci rt)
NestLoop(pi1 an n ci)
NestLoop(pi1 an n)
HashJoin(pi1 an)
IndexScan(pi1)
IndexScan(ci)
IndexScan(n)
SeqScan(it1)
SeqScan(an)
SeqScan(rt)
Leading((((((pi1 an) n) ci) rt) it1))
*/
 SELECT COUNT(*) 
 
FROM 
name as n,
(
    SELECT * FROM aka_name as an
    WHERE 
pg_lip_bloom_probe(1, an.person_id) 
) AS an,
info_type as it1,
(
    SELECT * FROM person_info as pi1
    WHERE 
pg_lip_bloom_probe(0, pi1.person_id) 
) AS pi1,
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
 AND (n.gender in ('m')) 
 AND (n.name_pcode_nf in ('A4524','E3632','G1641','G6212','J236','J265','J5213','J5215','J5254','J5635','M6265','N2421','N2423','P3632','W4524')) 
 AND (ci.note IS NULL) 
 AND (rt.role in ('actor')) 
 AND (it1.id in ('31')) 
  
;