/*+ HashJoin(mi_idx mc ct it t)
 NestLoop(mi_idx mc ct it)
 HashJoin(mi_idx mc ct)
 HashJoin(mi_idx mc)
 IndexScan(mi_idx)
 SeqScan(mc)
 SeqScan(ct)
 IndexScan(it)
 IndexScan(t)
 Leading(((((mi_idx mc) ct) it) t)) */
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info_idx AS mi_idx,
     title AS t
WHERE ct.kind = 'production companies'
  AND it.info = 'top 250 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND (mc.note LIKE '%(co-production)%'
       OR mc.note LIKE '%(presents)%')
  AND ct.id = mc.company_type_id
  AND t.id = mc.movie_id
  AND t.id = mi_idx.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND it.id = mi_idx.info_type_id;

