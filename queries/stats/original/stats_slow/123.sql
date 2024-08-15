SELECT COUNT(*)
FROM postHistory AS ph,
     posts AS p,
     users AS u,
     badges AS b
WHERE b.UserId = u.Id
  AND p.OwnerUserId = u.Id
  AND ph.UserId = u.Id
  AND p.AnswerCount>=0
  AND p.FavoriteCount>=0
  AND p.CreationDate<='2014-09-03 03:32:35'::timestamp
  AND u.CreationDate<='2014-09-12 22:21:49'::timestamp;