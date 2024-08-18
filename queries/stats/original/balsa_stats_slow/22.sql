SELECT COUNT(*)
FROM votes AS v,
     posts AS p,
     users AS u
WHERE v.UserId = p.OwnerUserId
  AND p.OwnerUserId = u.Id
  AND p.CommentCount>=0
  AND p.CommentCount<=12
  AND u.CreationDate>='2010-07-22 04:38:06'::timestamp
  AND u.CreationDate<='2014-09-08 15:55:02'::timestamp;