SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);

SELECT sum(pg_lip_bloom_add(0, v.UserId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp;

/*+
HashJoin(v ph c pl p b)
HashJoin(v ph c pl p)
HashJoin(ph c pl p)
HashJoin(c pl p)
HashJoin(pl p)
Leading(((v (ph (c (pl p)))) b))
*/
SELECT COUNT(*)
FROM (
        select * 
        from comments AS c
        where true
        and pg_lip_bloom_probe(0, c.UserId)
    ) as c,
     posts AS p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     badges AS b
WHERE p.Id = c.PostId
  AND p.Id = pl.RelatedPostId
  AND p.Id = ph.PostId
  AND p.Id = v.PostId
  AND b.UserId = c.UserId
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp;