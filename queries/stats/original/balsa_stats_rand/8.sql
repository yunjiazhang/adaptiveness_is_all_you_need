SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl
WHERE c.UserId = p.OwnerUserId
  AND p.Id = pl.PostId
  AND c.Score=0
  AND p.CreationDate>='2010-09-06 00:58:21'::timestamp
  AND p.CreationDate<='2014-09-12 10:02:21'::timestamp
  AND pl.LinkTypeId=1
  AND pl.CreationDate>='2011-07-09 22:35:44'::timestamp;