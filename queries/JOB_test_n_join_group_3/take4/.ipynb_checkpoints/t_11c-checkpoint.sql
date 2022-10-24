/*+ MergeJoin(ct lt k ml mk t mc cn)
 NestLoop(ct lt k ml mk t mc)
 NestLoop(lt k ml mk t mc)
 NestLoop(lt k ml mk t)
 NestLoop(k ml mk t)
 HashJoin(k ml mk)
 NestLoop(ml mk)
 SeqScan(ct)
 SeqScan(lt)
 IndexScan(k)
 IndexScan(ml)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 Leading(((ct ((lt ((k (ml mk)) t)) mc)) cn)) */
SELECT MIN(cn.name) AS from_company,
       MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_based_on_book
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '20th Century Fox%'
       OR cn.name LIKE 'Twentieth Century Fox%')
  AND ct.kind != 'production companies'
  AND ct.kind IS NOT NULL
  AND k.keyword IN ('sequel',
                    'revenge',
                    'based-on-novel')
  AND mc.note IS NOT NULL
  AND t.production_year > 1950
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;

