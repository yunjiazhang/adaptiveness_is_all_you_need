SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, n.id)), sum(pg_lip_bloom_add(1, n.id)) FROM name AS n 
        WHERE (((n.gender)::text = 'm'::text) AND (((n.name_pcode_nf)::text = ANY ('{A3525,A6361,C4562,D6424,F6535,G5356,G6212,I2652,J1435,J164,J5365,J6354,K3261,K6434,M253,M6216,M6252,P3626,P4126,P4546,R1424,R146,T252,T5414}'::text[])) OR (n.name_pcode_nf IS NULL))) AND (((n.gender)::text = 'm'::text) AND (((n.name_pcode_nf)::text = ANY ('{A3525,A6361,C4562,D6424,F6535,G5356,G6212,I2652,J1435,J164,J5365,J6354,K3261,K6434,M253,M6216,M6252,P3626,P4126,P4546,R1424,R146,T252,T5414}'::text[])) OR (n.name_pcode_nf IS NULL)));


/*+
NestLoop(it1 pi1 an n ci rt)
HashJoin(pi1 an n ci rt)
NestLoop(pi1 an n ci)
NestLoop(pi1 an n)
HashJoin(pi1 an)
IndexScan(ci)
SeqScan(it1)
SeqScan(pi1)
IndexScan(n)
SeqScan(an)
SeqScan(rt)
Leading((it1 ((((pi1 an) n) ci) rt)))
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
 AND (n.name_pcode_nf in ('A3525','A6361','C4562','D6424','F6535','G5356','G6212','I2652','J1435','J164','J5365','J6354','K3261','K6434','M253','M6216','M6252','P3626','P4126','P4546','R1424','R146','T252','T5414') OR n.name_pcode_nf IS NULL) 
 AND (ci.note in ('(executive producer)','(executive producer: Williams Street)','(supervising producer)','(uncredited)','(voice)') OR ci.note IS NULL) 
 AND (rt.role in ('actor','composer','director','producer')) 
 AND (it1.id in ('37')) 
  
;