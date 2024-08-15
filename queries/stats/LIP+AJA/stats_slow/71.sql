SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, v.PostId)) FROM votes as v WHERE TRUE
  AND v.VoteTypeId=5;
SELECT sum(pg_lip_bloom_add(1, ph.PostId)) FROM postHistory AS ph WHERE TRUE
  AND ph.PostHistoryTypeId=2;


/*+
HashJoin(pl p v ph c b)
HashJoin(pl p v ph c)
HashJoin(pl p v ph)
HashJoin(pl p v)
NestLoop(pl p)
IndexScan(pl)
Leading((b (c (ph (v (p pl))))))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     (
         select * 
         from postLinks AS pl
         where true 
         and pg_lip_bloom_probe(0, pl.RelatedPostId)
         and pg_lip_bloom_probe(1, pl.RelatedPostId)
     ) as pl,
     postHistory AS ph,
     votes AS v,
     badges AS b
WHERE p.Id = c.PostId
  AND p.Id = pl.RelatedPostId
  AND p.Id = ph.PostId
  AND p.Id = v.PostId
  AND b.UserId = c.UserId
  AND p.CommentCount>=0
  AND ph.PostHistoryTypeId=2
  AND v.VoteTypeId=5;