SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, ph.UserId)) FROM postHistory AS ph WHERE ph.CreationDate<='2014-08-18 08:54:12'::timestamp;
SELECT sum(pg_lip_bloom_add(1, u.Id)) FROM users AS u WHERE u.Views=0
  AND u.DownVotes>=0
  AND u.DownVotes<=60;
SELECT sum(pg_lip_bloom_add(2, p.OwnerUserId)) FROM posts AS p WHERE p.Score>=-2
  AND p.CommentCount>=0
  AND p.CommentCount<=12
  AND p.FavoriteCount>=0
  AND p.FavoriteCount<=6;


/*+
HashJoin(b p ph c u)
NestLoop(u c)
NestLoop(b p ph)
NestLoop(p b)
IndexScan(b)
IndexScan(c)
Leading((((p b) ph) (u c)))
*/
SELECT COUNT(*)
FROM (
        SELECT * 
        FROM comments AS c
        WHERE TRUE
            AND pg_lip_bloom_probe(1, c.UserId)
            AND pg_lip_bloom_probe(2, c.UserId)
     ) AS c,
     posts AS p,
     postHistory AS ph,
     (
         SELECT * 
         FROM badges AS b
         WHERE True
             AND pg_lip_bloom_probe(0, b.UserId)
             AND pg_lip_bloom_probe(1, b.UserId)
     ) AS b,
     users AS u
WHERE u.Id = ph.UserId
  AND u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = c.UserId
  AND c.Score=0
  AND p.Score>=-2
  AND p.CommentCount>=0
  AND p.CommentCount<=12
  AND p.FavoriteCount>=0
  AND p.FavoriteCount<=6
  AND ph.CreationDate<='2014-08-18 08:54:12'::timestamp
  AND u.Views=0
  AND u.DownVotes>=0
  AND u.DownVotes<=60;