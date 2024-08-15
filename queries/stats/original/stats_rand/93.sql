SELECT COUNT(*)
FROM votes AS v,
     posts AS p,
     users AS u
WHERE v.UserId = u.Id
  AND p.OwnerUserId = u.Id
  AND p.PostTypeId=2
  AND p.CreationDate<='2014-08-26 22:40:26'::timestamp
  AND u.Views>=0;