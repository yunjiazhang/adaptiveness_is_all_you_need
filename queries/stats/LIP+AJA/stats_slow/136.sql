SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, p.OwnerUserId)) FROM posts AS p WHERE TRUE
  AND p.PostTypeId=1
  AND p.ViewCount>=0
  AND p.ViewCount<=25597
  AND p.CommentCount>=0
  AND p.CommentCount<=11
  AND p.FavoriteCount>=0;
SELECT sum(pg_lip_bloom_add(1, c.UserId)) FROM comments AS c WHERE TRUE
  AND c.CreationDate>='2010-08-19 09:33:49'::timestamp
  AND c.CreationDate<='2014-08-28 06:54:21'::timestamp;  
SELECT sum(pg_lip_bloom_add(2, u.Id)) FROM users AS u WHERE TRUE
  AND u.DownVotes<=0
  AND u.UpVotes>=0
  AND u.UpVotes<=123;  
  

  
/*+
HashJoin(b p ph c u)
HashJoin(c u)
NestLoop(b p ph)
HashJoin(b p)
Leading((((b p) ph) (c u)))
*/
SELECT COUNT(*)
FROM 
    (
        SELECT * 
        FROM comments AS c
        WHERE True
        AND pg_lip_bloom_probe(0, c.UserId) 
    ) as c,
     posts AS p,
     postHistory AS ph,
     (
         SELECT * 
         FROM badges AS b
         WHERE TRUE 
         AND pg_lip_bloom_probe(1, b.UserId)
         AND pg_lip_bloom_probe(2, b.UserId)
     ) as b,
     users AS u
WHERE u.Id = ph.UserId
  AND u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = c.UserId
  AND c.CreationDate>='2010-08-19 09:33:49'::timestamp
  AND c.CreationDate<='2014-08-28 06:54:21'::timestamp
  AND p.PostTypeId=1
  AND p.ViewCount>=0
  AND p.ViewCount<=25597
  AND p.CommentCount>=0
  AND p.CommentCount<=11
  AND p.FavoriteCount>=0
  AND u.DownVotes<=0
  AND u.UpVotes>=0
  AND u.UpVotes<=123;