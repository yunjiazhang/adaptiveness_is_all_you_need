SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, v.PostId)) FROM votes AS v WHERE v.CreationDate<='2014-09-12 00:00:00'::timestamp;
  

/*+
HashJoin(c p u v)
HashJoin(c p u)
HashJoin(c p)
Leading((v ((c p) u)))
*/
SELECT COUNT(*)
FROM 
(
    select * 
    from comments AS c
    where pg_lip_bloom_probe(0, c.PostId)
    
) as c,
     posts AS p,
     votes AS v,
     users AS u
WHERE u.Id = p.OwnerUserId
  AND p.Id = v.PostId
  AND p.Id = c.PostId
  AND c.Score=0
  AND c.CreationDate<='2014-09-10 02:47:53'::timestamp
  AND p.Score>=0
  AND p.Score<=19
  AND p.CommentCount<=10
  AND p.CreationDate<='2014-08-28 13:31:33'::timestamp
  AND v.CreationDate<='2014-09-12 00:00:00'::timestamp
  AND u.DownVotes>=0;