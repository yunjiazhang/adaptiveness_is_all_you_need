SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
-- SELECT sum(pg_lip_bloom_add(0, cn.id)) FROM company_name AS cn WHERE cn.country_code ='[us]';
-- SELECT sum(pg_lip_bloom_add(1, rt.id)) FROM role_type AS rt WHERE rt.role ='writer';

/*+
HashJoin(ci rt mc n1 t a1 cn)
HashJoin(ci rt mc n1 t a1)
HashJoin(ci rt mc n1 t)
HashJoin(ci rt mc n1)
HashJoin(ci rt mc)
NestLoop(ci rt)
SeqScan(ci)
IndexScan(rt)
SeqScan(mc)
SeqScan(n1)
SeqScan(t)
SeqScan(a1)
SeqScan(cn)
Leading(((((((rt ci) mc) n1) t) a1) cn))*/
SELECT MIN(a1.name) AS writer_pseudo_name,
       MIN(t.title) AS movie_title
 FROM 
aka_name AS a1 ,
(
	SELECT * FROM cast_info AS ci 
	--  WHERE pg_lip_bloom_probe(1, ci.role_id)
) AS ci ,
company_name AS cn ,
(
	SELECT * FROM movie_companies AS mc 
	--  WHERE pg_lip_bloom_probe(0, mc.company_id)
) AS mc ,
name AS n1 ,
role_type AS rt ,
title AS t
WHERE
 cn.country_code ='[us]'
  AND rt.role ='writer'
  AND a1.person_id = n1.id
  AND n1.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND a1.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id;
