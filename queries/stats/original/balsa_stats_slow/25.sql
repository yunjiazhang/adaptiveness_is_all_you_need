SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl,
     votes AS v
WHERE p.Id = c.PostId
  AND c.PostId = pl.PostId
  AND pl.PostId = v.PostId
  AND c.CreationDate>='2010-08-02 23:52:10'::timestamp
  AND p.Score>=-3
  AND v.VoteTypeId=2
  AND v.CreationDate<='2014-09-12 00:00:00'::timestamp;