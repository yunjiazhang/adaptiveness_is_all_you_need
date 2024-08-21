SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);

SELECT sum(pg_lip_bloom_add(0, v.PostId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp;


/*+
NestLoop(ph c pl p v b)
HashJoin(ph c pl p v)
NestLoop(c pl p v)
HashJoin(c pl p)
HashJoin(pl p)
Leading(((ph ((c (pl p)) v)) b))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     (
         select * 
         from postLinks AS pl
         where pg_lip_bloom_probe(0, pl.RelatedPostId)
     ) as pl,
     postHistory AS ph,
     votes AS v,
     badges AS b
WHERE p.Id = c.PostId
  AND p.Id = pl.RelatedPostId
  AND p.Id = ph.PostId
  AND p.Id = v.PostId
  AND b.UserId = c.UserId
  AND c.Score=0
  AND p.Score<=32
  AND p.ViewCount<=4146
  AND pl.LinkTypeId=1
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp;