SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);


/*+
HashJoin(b p pl c u ph v)
NestLoop(p pl c u ph v)
NestLoop(p pl c u ph)
NestLoop(p pl c u)
NestLoop(p pl c)
HashJoin(p pl)
Leading((b (((((pl p) c) u) ph) v)))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     badges AS b,
     users AS u
WHERE p.Id = pl.RelatedPostId
  AND b.UserId = u.Id
  AND c.UserId = u.Id
  AND p.Id = v.PostId
  AND p.Id = c.PostId
  AND p.Id = ph.PostId
  AND p.Score<=40
  AND p.CommentCount>=0
  AND p.CreationDate>='2010-07-28 17:40:56'::timestamp
  AND p.CreationDate<='2014-09-11 04:22:44'::timestamp
  AND pl.LinkTypeId=1;