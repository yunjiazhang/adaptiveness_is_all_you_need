/*+
NestLoop(p pl c)
NestLoop(p pl)
Leading(((p pl) c))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl
WHERE c.UserId = p.OwnerUserId
  AND p.Id = pl.PostId
  AND p.CommentCount<=18
  AND p.CreationDate>='2010-07-23 07:27:31'::timestamp
  AND p.CreationDate<='2014-09-09 01:43:00'::timestamp;