SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, c.PostId)) FROM comments AS c WHERE c.CreationDate>='2010-08-02 23:52:10'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.PostId)) FROM votes AS v WHERE v.VoteTypeId=2
  AND v.CreationDate<='2014-09-12 00:00:00'::timestamp;

/*+
NestLoop(pl p c v)
NestLoop(pl p c)
HashJoin(pl p)
Leading((((pl p) c) v))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     (
         select * 
         from postLinks AS pl
         where true
         and pg_lip_bloom_probe(0, pl.PostId)
         and pg_lip_bloom_probe(1, pl.PostId)
     ) as pl,
     votes AS v
WHERE p.Id = c.PostId
  AND c.PostId = pl.PostId
  AND pl.PostId = v.PostId
  AND c.CreationDate>='2010-08-02 23:52:10'::timestamp
  AND p.Score>=-3
  AND v.VoteTypeId=2
  AND v.CreationDate<='2014-09-12 00:00:00'::timestamp;