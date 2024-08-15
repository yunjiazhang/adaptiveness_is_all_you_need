SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, UserId)) FROM comments AS c WHERE c.Score=1
  AND c.CreationDate>='2010-07-20 23:17:28'::timestamp;


/*+
HashJoin(c b v u)
NestLoop(b v u)
NestLoop(v u)
Leading((c ((u v) b)))
*/
SELECT COUNT(*)
FROM comments AS c,
     votes AS v,
     (
         SELECT * FROM
         badges AS b
         WHERE pg_lip_bloom_probe(0, b.UserId)
     ) AS b,
     users AS u
WHERE u.Id = b.UserId
  AND u.Id = c.UserId
  AND u.Id = v.UserId
  AND c.Score=1
  AND c.CreationDate>='2010-07-20 23:17:28'::timestamp
  AND u.CreationDate>='2010-07-20 01:27:29'::timestamp;