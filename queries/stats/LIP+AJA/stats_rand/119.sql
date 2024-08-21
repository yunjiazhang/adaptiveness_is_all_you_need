SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);
SELECT sum(pg_lip_bloom_add(0, p.OwnerUserId)) FROM posts AS p where p.ViewCount>=0
  AND p.ViewCount<=2024;
SELECT sum(pg_lip_bloom_add(1, u.Id)) FROM users AS u where u.Reputation>=1
  AND u.Reputation<=750;
SELECT sum(pg_lip_bloom_add(2, b.UserId)) FROM badges AS b where b.Date>='2010-07-20 10:34:10'::timestamp;
SELECT sum(pg_lip_bloom_add(3, ph.UserId)) FROM postHistory AS ph where ph.PostHistoryTypeId=5;


/*+
HashJoin(p ph u v)
NestLoop(p ph u)
NestLoop(p ph)
Leading((v ((p ph) u)))
*/
SELECT COUNT(*)
FROM 
    (
        select * 
        from postHistory AS ph
        where true 
        and pg_lip_bloom_probe(0, ph.UserId)
        and pg_lip_bloom_probe(1, ph.UserId)
     ) as ph,
     (
         select * 
         from posts AS p
         where true
         and pg_lip_bloom_probe(2, p.OwnerUserId)
         and pg_lip_bloom_probe(3, p.OwnerUserId)
     ) as p,
     users AS u,
     badges AS b
WHERE b.UserId = u.Id
  AND p.OwnerUserId = u.Id
  AND ph.UserId = u.Id
  AND ph.PostHistoryTypeId=5
  AND p.ViewCount>=0
  AND p.ViewCount<=2024
  AND u.Reputation>=1
  AND u.Reputation<=750
  AND b.Date>='2010-07-20 10:34:10'::timestamp;