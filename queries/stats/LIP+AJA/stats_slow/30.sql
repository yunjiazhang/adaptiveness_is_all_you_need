SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);

/*+
HashJoin(b v p u)
HashJoin(v p u)
HashJoin(p u)
Leading((b (v (p u))))
*/
SELECT COUNT(*)
FROM votes AS v,
     posts AS p,
     badges AS b,
     users AS u
WHERE u.Id = v.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = b.UserId
  AND p.Score>=0
  AND p.Score<=30
  AND p.CommentCount=0
  AND p.CreationDate>='2010-07-27 15:30:31'::timestamp
  AND p.CreationDate<='2014-09-04 17:45:10'::timestamp;