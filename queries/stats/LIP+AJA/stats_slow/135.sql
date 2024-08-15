SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, p.OwnerUserId)) FROM posts AS p WHERE TRUE
  AND p.PostTypeId=1
  AND p.ViewCount>=0
  AND p.ViewCount<=4157
  AND p.FavoriteCount=0
  AND p.CreationDate<='2014-09-08 09:58:16'::timestamp;
SELECT sum(pg_lip_bloom_add(1, c.UserId)) FROM comments as c WHERE c.Score=0;

/*+
HashJoin(ph p b c u)
HashJoin(ph p b)
NestLoop(p b)
HashJoin(c u)
Leading(((ph (p b)) (c u)))
*/
SELECT COUNT(*)
FROM (
        select * 
        from comments AS c
        where true
        and pg_lip_bloom_probe(0, c.UserId)
     ) as c,
     (
         select * 
         from posts AS p
         where true
         and pg_lip_bloom_probe(1, p.OwnerUserId)
     ) as p,
     postHistory AS ph,
     badges AS b,
     users AS u
WHERE u.Id = ph.UserId
  AND u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = c.UserId
  AND c.Score=0
  AND p.PostTypeId=1
  AND p.ViewCount>=0
  AND p.ViewCount<=4157
  AND p.FavoriteCount=0
  AND p.CreationDate<='2014-09-08 09:58:16'::timestamp;