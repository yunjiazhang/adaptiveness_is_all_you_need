SELECT COUNT(*)
FROM comments AS c,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     posts AS p
WHERE pl.PostId = p.Id
  AND c.PostId = p.Id
  AND v.PostId = p.Id
  AND ph.PostId = p.Id
  AND pl.LinkTypeId=1
  AND pl.CreationDate>='2010-10-19 15:02:42'::timestamp
  AND ph.CreationDate<='2014-06-18 17:14:07'::timestamp
  AND v.CreationDate>='2010-07-20 00:00:00'::timestamp;