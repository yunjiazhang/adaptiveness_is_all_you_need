SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(t1 s tq1 q1 u1 b1 acc)
NestLoop(t1 s tq1 q1 u1 b1)
NestLoop(t1 s tq1 q1 u1)
NestLoop(t1 s tq1 q1)
NestLoop(t1 s tq1)
HashJoin(t1 s)
IndexScan(tq1)
IndexScan(acc)
IndexScan(q1)
IndexScan(u1)
IndexScan(b1)
SeqScan(t1)
SeqScan(s)
Leading(((((((t1 s) tq1) q1) u1) b1) acc))
*/
 SELECT b1.name, count(*) 
 
FROM 
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE 
 
 s.site_id = u1.site_id 
 AND s.site_id = b1.site_id 
 AND s.site_id = t1.site_id 
 AND s.site_id = tq1.site_id 
 AND s.site_id = q1.site_id 
 AND t1.id = tq1.tag_id 
 AND q1.id = tq1.question_id 
 AND q1.owner_user_id = u1.id 
 AND acc.id = u1.account_id 
 AND b1.user_id = u1.id 
 AND (q1.favorite_count >= 5) 
 AND (q1.favorite_count <= 5000) 
 AND (s.site_name in ('stackoverflow','superuser')) 
 AND (t1.name in ('.net-4.5','active-directory','backup','bundler','eclipse-plugin','event-handling','filter','overriding','primefaces','resources','sbt','scrapy','vagrant','virtualization')) 
 AND (acc.website_url ILIKE ('%com')) 
 GROUP BY b1.name 
 ORDER BY COUNT(*) 
 DESC 
 LIMIT 100 
  
;