SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);

SELECT sum(pg_lip_bloom_add(0, ph.PostId)) FROM postHistory AS ph WHERE TRUE
  AND ph.CreationDate<='2014-09-11 20:09:41'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.PostId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate>='2010-07-21 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-14 00:00:00'::timestamp;


/*+
HashJoin(b c pl p u v ph)
NestLoop(c pl p u v ph)
NestLoop(c pl p u v)
NestLoop(c pl p u)
HashJoin(c pl p)
HashJoin(pl p)
Leading((b ((((c (pl p)) u) v) ph)))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         select * 
         from posts AS p
         where TRUE 
         -- AND pg_lip_bloom_probe(0, p.Id)
         -- AND pg_lip_bloom_probe(1, p.Id)
     ) AS p,
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
  AND c.Score=0
  AND c.CreationDate>='2010-07-26 17:09:48'::timestamp
  AND p.PostTypeId=1
  AND p.AnswerCount>=0
  AND p.CommentCount>=0
  AND p.CommentCount<=14
  AND pl.CreationDate>='2010-10-27 10:02:57'::timestamp
  AND pl.CreationDate<='2014-09-04 17:23:50'::timestamp
  AND ph.CreationDate<='2014-09-11 20:09:41'::timestamp
  AND v.CreationDate>='2010-07-21 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-14 00:00:00'::timestamp;