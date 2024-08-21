SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE TRUE
  AND c.Score=0
  AND c.CreationDate>='2010-09-05 16:04:35'::timestamp
  AND c.CreationDate<='2014-09-11 04:35:36'::timestamp;
SELECT sum(pg_lip_bloom_add(1, ph.UserId)) FROM postHistory AS ph WHERE TRUE
  AND ph.PostHistoryTypeId=1
  AND ph.CreationDate>='2010-07-26 20:01:58'::timestamp
  AND ph.CreationDate<='2014-09-13 17:29:23'::timestamp;
SELECT sum(pg_lip_bloom_add(2, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date<='2014-09-04 08:54:56'::timestamp;


/*+
HashJoin(c u v b)
NestLoop(u c)
NestLoop(ph b)
Leading(((ph b) (u c)))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         select * 
         from postHistory AS ph
         where pg_lip_bloom_probe(0, ph.UserId)
     ) as ph,
     badges AS b,
     (
         select * 
         from users AS u
         where true
         and pg_lip_bloom_probe(1, u.Id)
         and pg_lip_bloom_probe(2, u.Id)
     ) as u
WHERE u.Id = c.UserId
  AND u.Id = ph.UserId
  AND u.Id = b.UserId
  AND c.Score=0
  AND c.CreationDate>='2010-09-05 16:04:35'::timestamp
  AND c.CreationDate<='2014-09-11 04:35:36'::timestamp
  AND ph.PostHistoryTypeId=1
  AND ph.CreationDate>='2010-07-26 20:01:58'::timestamp
  AND ph.CreationDate<='2014-09-13 17:29:23'::timestamp
  AND b.Date<='2014-09-04 08:54:56'::timestamp;