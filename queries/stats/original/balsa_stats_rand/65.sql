SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     users AS u
WHERE p.Id = pl.PostId
  AND p.Id = ph.PostId
  AND p.Id = c.PostId
  AND u.Id = c.UserId
  AND u.Id = v.UserId
  AND c.Score=0
  AND c.CreationDate>='2010-07-20 06:26:28'::timestamp
  AND c.CreationDate<='2014-09-11 18:45:09'::timestamp
  AND p.PostTypeId=1
  AND p.FavoriteCount>=0
  AND p.FavoriteCount<=2
  AND ph.PostHistoryTypeId=5
  AND u.DownVotes<=0
  AND u.UpVotes>=0
  AND u.CreationDate>='2010-09-18 01:58:41'::timestamp;