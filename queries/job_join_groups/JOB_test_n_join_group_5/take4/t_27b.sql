/*+ NestLoop(cct2 cn ct lt ml k mk mc t cc cct1 mi)
 HashJoin(cct2 cn ct lt ml k mk mc t cc cct1)
 NestLoop(cn ct lt ml k mk mc t cc cct1)
 HashJoin(cn ct lt ml k mk mc t cc)
 NestLoop(ct lt ml k mk mc t cc)
 HashJoin(ct lt ml k mk mc t)
 NestLoop(lt ml k mk mc t)
 NestLoop(lt ml k mk mc)
 NestLoop(ml k mk mc)
 HashJoin(ml k mk)
 NestLoop(k mk)
 IndexScan(cct2)
 SeqScan(cn)
 SeqScan(ct)
 SeqScan(lt)
 SeqScan(ml)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(cct1)
 IndexScan(mi)
 Leading(((cct2 ((cn ((ct ((lt ((ml (k mk)) mc)) t)) cc)) cct1)) mi)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cct1.kind IN ('cast',
                    'crew')
  AND cct2.kind = 'complete'
  AND cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Germany',
                  'Swedish',
                  'German')
  AND t.production_year = 1998
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND t.id = cc.movie_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id
  AND ml.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = cc.movie_id;
