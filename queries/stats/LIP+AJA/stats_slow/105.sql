SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE c.Score=0
  AND c.CreationDate>='2010-07-19 19:56:21'::timestamp
  AND c.CreationDate<='2014-09-11 13:36:12'::timestamp;
SELECT sum(pg_lip_bloom_add(0, u.Id)) FROM users AS u WHERE u.Views<=433
  AND u.DownVotes>=0
  AND u.CreationDate<='2014-09-12 21:37:39'::timestamp;
  

/*+
HashJoin(ph v c u)
NestLoop(c u)
NestLoop(ph v)
Leading(((ph v) (c u)))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         SELECT *
         FROM postHistory AS ph
         WHERE pg_lip_bloom_probe(0, ph.UserId)
     ) AS ph,
     votes AS v,
     users AS u
WHERE v.UserId = u.Id
  AND c.UserId = u.Id
  AND ph.UserId = u.Id
  AND c.Score=0
  AND c.CreationDate>='2010-07-19 19:56:21'::timestamp
  AND c.CreationDate<='2014-09-11 13:36:12'::timestamp
  AND u.Views<=433
  AND u.DownVotes>=0
  AND u.CreationDate<='2014-09-12 21:37:39'::timestamp;