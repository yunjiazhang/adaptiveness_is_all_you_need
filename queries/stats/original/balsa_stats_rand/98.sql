SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     votes AS v,
     users AS u
WHERE u.Id = p.OwnerUserId
  AND u.Id = c.UserId
  AND u.Id = v.UserId
  AND p.Score<=52
  AND p.AnswerCount>=0
  AND v.CreationDate>='2010-07-20 00:00:00'::timestamp
  AND u.UpVotes>=0
  AND u.CreationDate>='2010-10-05 05:52:35'::timestamp
  AND u.CreationDate<='2014-09-08 15:55:02'::timestamp;