SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date<='2014-09-06 17:33:22'::timestamp;


/*+
NestLoop(t p u v b)
NestLoop(t p u v)
NestLoop(t p u)
NestLoop(t p)
Leading(((((t p) u) v) b))
*/
SELECT COUNT(*)
FROM tags AS t,
     (
         SELECT * 
         FROM posts AS p
         WHERE pg_lip_bloom_probe(0, p.OwnerUserId)
     ) as p,
     users AS u,
     votes AS v,
     badges AS b
WHERE u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = v.UserId
  AND p.Id = t.ExcerptPostId
  AND p.CommentCount>=0
  AND p.CommentCount<=13
  AND u.Reputation>=1
  AND b.Date<='2014-09-06 17:33:22'::timestamp;