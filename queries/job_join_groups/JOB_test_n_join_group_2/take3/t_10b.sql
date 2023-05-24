/*+ NestLoop(t mc cn ct ci chn rt)
 NestLoop(t mc cn ct ci chn)
 NestLoop(t mc cn ct ci)
 NestLoop(t mc cn ct)
 NestLoop(t mc cn)
 NestLoop(t mc)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ct)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(rt)
 Leading(((((((t mc) cn) ct) ci) chn) rt)) */
SELECT MIN(chn.name) AS character,
       MIN(t.title) AS russian_mov_with_actor_producer
FROM char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     company_type AS ct,
     movie_companies AS mc,
     role_type AS rt,
     title AS t
WHERE ci.note LIKE '%(producer)%'
  AND cn.country_code = '[ru]'
  AND rt.role = 'actor'
  AND t.production_year > 2010
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND chn.id = ci.person_role_id
  AND rt.id = ci.role_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;
