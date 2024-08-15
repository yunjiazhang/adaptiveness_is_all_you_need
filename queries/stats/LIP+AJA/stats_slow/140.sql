SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);

-- SELECT sum(pg_lip_bloom_add(0, p.Id)) FROM posts AS p WHERE TRUE
--   AND p.ViewCount>=0
--   AND p.AnswerCount<=5
--   AND p.CommentCount<=12
--   AND p.FavoriteCount>=0;
-- SELECT sum(pg_lip_bloom_add(1, pl.RelatedPostId)) FROM postLinks AS pl WHERE TRUE
--   AND pl.LinkTypeId=1
--   AND pl.CreationDate>='2011-02-16 20:04:50'::timestamp
--   AND pl.CreationDate<='2014-09-01 16:48:04'::timestamp;
SELECT sum(pg_lip_bloom_add(2, v.PostId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-08-31 00:00:00'::timestamp;
SELECT sum(pg_lip_bloom_add(3, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date>='2010-08-06 10:36:45'::timestamp
  AND b.Date<='2014-09-12 07:19:35'::timestamp;



/*+
HashJoin(pl p c u v ph b)
NestLoop(pl p c u v ph)
NestLoop(pl p c u v)
NestLoop(pl p c u)
NestLoop(pl p c)
NestLoop(pl p)
IndexScan(b)
IndexScan(ph)
IndexScan(v)
IndexScan(u)
IndexScan(c)
IndexScan(p)
SeqScan(pl)
Leading((b (((((pl p) c) u) v) ph)))
*/
SELECT COUNT(*)
FROM (
        select * 
        from comments AS c
        where true
        and pg_lip_bloom_probe(3, c.UserId)
     ) AS c,
     posts AS p,
     (
         SELECT *
         FROM postLinks AS pl
         WHERE TRUE
         AND pg_lip_bloom_probe(2, pl.RelatedPostId)
     ) as pl,
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
  AND p.ViewCount>=0
  AND p.AnswerCount<=5
  AND p.CommentCount<=12
  AND p.FavoriteCount>=0
  AND pl.LinkTypeId=1
  AND pl.CreationDate>='2011-02-16 20:04:50'::timestamp
  AND pl.CreationDate<='2014-09-01 16:48:04'::timestamp
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-08-31 00:00:00'::timestamp
  AND b.Date>='2010-08-06 10:36:45'::timestamp
  AND b.Date<='2014-09-12 07:19:35'::timestamp;