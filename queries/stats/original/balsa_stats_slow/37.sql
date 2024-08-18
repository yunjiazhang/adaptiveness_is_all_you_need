SELECT COUNT(*)
FROM comments AS c,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v
WHERE pl.PostId = c.PostId
  AND c.PostId = ph.PostId
  AND ph.PostId = v.PostId
  AND ph.CreationDate>='2011-05-07 21:47:19'::timestamp
  AND ph.CreationDate<='2014-09-10 13:19:54'::timestamp;