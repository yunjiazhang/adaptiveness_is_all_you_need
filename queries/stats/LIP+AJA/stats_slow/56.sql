SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, u.Id)) FROM users AS u WHERE TRUE
  AND u.DownVotes>=0;



SELECT COUNT(*)
FROM tags AS t,
     (
         select * 
         from posts AS p
         where true
         and pg_lip_bloom_probe(0, p.OwnerUserId)
     ) as p,
     users AS u,
     votes AS v,
     badges AS b
WHERE p.Id = t.ExcerptPostId
  AND u.Id = v.UserId
  AND u.Id = b.UserId
  AND u.Id = p.OwnerUserId
  AND u.DownVotes>=0;