SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);

SELECT COUNT(*)
FROM postHistory AS ph,
     votes AS v,
     users AS u,
     badges AS b
WHERE u.Id = b.UserId
  AND u.Id = ph.UserId
  AND u.Id = v.UserId
  AND u.Views>=0;
  