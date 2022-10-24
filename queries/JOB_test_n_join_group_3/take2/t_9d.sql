/*+ NestLoop(n ci rt chn mc cn an t)
 NestLoop(n ci rt chn mc cn an)
 NestLoop(n ci rt chn mc cn)
 NestLoop(n ci rt chn mc)
 NestLoop(n ci rt chn)
 NestLoop(n ci rt)
 NestLoop(n ci)
 SeqScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(an)
 IndexScan(t)
 Leading((((((((n ci) rt) chn) mc) cn) an) t)) */
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND n.gender ='f'
  AND rt.role ='actress'
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND ci.movie_id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;

