SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0,  c.PostId)) FROM comments AS c WHERE c.CreationDate>='2010-07-21 11:05:37'::timestamp
  AND c.CreationDate<='2014-08-25 17:59:25'::timestamp;

/*+
NestLoop(pl p u c)
HashJoin(pl p u)
HashJoin(pl p)
Leading((((pl p) u) c))
*/
SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     (
         select *
         from postLinks AS pl
         where true
         and pg_lip_bloom_probe(0, pl.PostId)
     ) as pl,
     users AS u
WHERE p.Id = c.PostId
  AND p.Id = pl.RelatedPostId
  AND p.OwnerUserId = u.Id
  AND c.CreationDate>='2010-07-21 11:05:37'::timestamp
  AND c.CreationDate<='2014-08-25 17:59:25'::timestamp
  AND u.UpVotes>=0
  AND u.CreationDate>='2010-08-21 21:27:38'::timestamp;