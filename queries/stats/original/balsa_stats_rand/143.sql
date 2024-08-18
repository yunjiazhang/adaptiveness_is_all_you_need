SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     badges AS b,
     users AS u
WHERE p.Id = pl.RelatedPostId
  AND b.UserId = u.Id
  AND c.UserId = u.Id
  AND p.Id = v.PostId
  AND p.Id = c.PostId
  AND p.Id = ph.PostId
  AND c.CreationDate>='2010-08-01 19:11:47'::timestamp
  AND c.CreationDate<='2014-09-11 13:42:51'::timestamp
  AND p.AnswerCount<=4
  AND p.FavoriteCount>=0
  AND pl.LinkTypeId=1
  AND v.VoteTypeId=2
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp
  AND b.Date<='2014-08-02 12:24:29'::timestamp;