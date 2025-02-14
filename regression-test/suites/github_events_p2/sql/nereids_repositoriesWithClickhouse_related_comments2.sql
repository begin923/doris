SET enable_nereids_planner=TRUE;
SET enable_fallback_to_original_planner=FALSE;
SELECT
    repo_name,
    sum(num_star) AS num_stars,
    sum(num_comment) AS num_comments
FROM
(
    SELECT
        repo_name,
        CASE WHEN event_type = 'WatchEvent' THEN 1 ELSE 0 END AS num_star,
        CASE WHEN lower(body) LIKE '%clickhouse%' THEN 1 ELSE 0 END AS num_comment
    FROM github_events
    WHERE (lower(body) LIKE '%clickhouse%') OR (event_type = 'WatchEvent')
) t
GROUP BY repo_name
HAVING num_comments > 0
ORDER BY num_stars DESC,num_comments DESC,repo_name ASC
LIMIT 50
