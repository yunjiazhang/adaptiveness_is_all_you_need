SELECT COUNT(*)
FROM comments AS c,
     postHistory AS ph,
     votes AS v,
     posts AS p
WHERE ph.PostId = p.Id
  AND c.PostId = p.Id
  AND v.PostId = p.Id
  AND c.Score=0
  AND c.CreationDate>='2010-08-26 06:55:11'::timestamp
  AND ph.CreationDate<='2014-09-05 06:39:25'::timestamp
  AND v.VoteTypeId=2;