SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE TRUE
  AND c.CreationDate>='2010-07-31 05:18:59'::timestamp
  AND c.CreationDate<='2014-09-12 07:59:13'::timestamp;
SELECT sum(pg_lip_bloom_add(1, ph.UserId)) FROM postHistory AS ph WHERE TRUE
  AND ph.PostHistoryTypeId=2;



/*+
HashJoin(c ph u p b)
HashJoin(ph u p b)
NestLoop(u p b)
NestLoop(u p)
Leading((c (ph ((u p) b))))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postHistory AS ph,
     badges AS b,
     (
         select * 
         from users AS u
         where true
         and pg_lip_bloom_probe(0, u.Id)
         and pg_lip_bloom_probe(1, u.Id)
     ) as u
WHERE u.Id = c.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = ph.UserId
  AND u.Id = b.UserId
  AND c.CreationDate>='2010-07-31 05:18:59'::timestamp
  AND c.CreationDate<='2014-09-12 07:59:13'::timestamp
  AND p.Score>=-2
  AND p.ViewCount>=0
  AND p.ViewCount<=18281
  AND ph.PostHistoryTypeId=2
  AND b.Date>='2010-10-20 08:33:44'::timestamp
  AND u.Views>=0
  AND u.Views<=75;