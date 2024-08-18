SELECT COUNT(*)
FROM votes AS v,
     posts AS p,
     badges AS b,
     users AS u
WHERE u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND p.Id = v.PostId
  AND p.AnswerCount>=0
  AND p.AnswerCount<=7
  AND p.CreationDate<='2014-09-12 00:03:32'::timestamp
  AND b.Date<='2014-09-11 07:27:36'::timestamp;