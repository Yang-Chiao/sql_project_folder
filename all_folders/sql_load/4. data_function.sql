SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date

FROM job_postings_fact

LIMIT 10;


SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
    
FROM job_postings_fact

WHERE job_title_short = 'Data Analyst'
GROUP BY date_month

ORDER BY job_posted_count;


-- January
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

-- April
CREATE TABLE april_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

-- May
CREATE TABLE may_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

-- June
CREATE TABLE june_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

-- July
CREATE TABLE july_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

-- August
CREATE TABLE august_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

-- September
CREATE TABLE september_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

-- October
CREATE TABLE october_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

-- November
CREATE TABLE november_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

-- December
CREATE TABLE december_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 12;


select job_posted_date 
FROM march_jobs

LIMIT 15;

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS avg_year_salary,
    AVG(salary_hour_avg) AS avg_hour_salary
    
FROM job_postings_fact

WHERE job_posted_date ::date >  '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;

SELECT 
    Count(*) AS job_posting,
    EXTRACT(MONTH FROM  job_posted_date AT TIME ZONE'UTC' AT TIME ZONE 'America/New_York' ) AS MONTH
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023
GROUP BY MONTH
ORDER BY MONTH;


SELECT 
    cd.company_id AS id,
    cd.name AS name,
    COUNT(*) AS job_count

FROM job_postings_fact AS jb
INNER JOIN company_dim AS cd
    ON jb.company_id = cd.company_id
WHERE 
    jb.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM job_posted_date) =2
GROUP BY cd.company_id
ORDER BY job_count DESC;


SELECT  
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'remote'
        WHEN job_location = 'New York, NY' THEN 'local'
        ELSE 'Onsite'
    END AS location_catagory
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_catagory;


SELECT
    job_id,
    job_title,
    AVG(salary_year_avg) AS AVERAGE_S,
        CASE 
            WHEN salary_year_avg >= 100000 THEN 'High salary'
            WHEN salary_year_avg >=60000 and salary_year_avg < 100000 THEN 'Standard salary'
            ELSE 'Low Salary'
        END AS salary_catagory
FROM 
    job_postings_fact
Where 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL

ORDER BY salary_year_avg DESC;

SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS num_company_remote,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS num_company_on_site
FROM job_postings_fact;

SELECT 
    job_id,
    salary_year_avg,   
    CASE 
        WHEN   job_title ILIKE '%Senior%' THEN 'Level-01'
        WHEN  job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%'THEN 'Level-02'
        WHEN  job_title ILIKE '%Junior%' OR job_title ILIKE '%/Entry%'THEN 'Level-03'
        ELSE 'Level-04'
    END AS job_catagory,
    CASE
        WHEN job_work_from_home = TRUE THEN 'YES'
        ELSE 'NO'
    END AS work_from_home
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_id;


SELECT *
FROM (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date)=1

)AS january_jobs;

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1
)

SELECT * 
FROM january_jobs;

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN(

    SELECT 
        company_id
        
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
)

WITH company_job_count AS (
SELECT 
    company_id,
    COUNT(*) AS total_jobs
FROM 
    job_postings_fact
GROUP BY company_id)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;

WITH remote_job_skills AS(
    SELECT 
        
        skill_id,
        COUNT(*) AS skill_count

    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS jb ON jb.job_id = skills_to_job.job_id
    WHERE   
        jb.job_work_from_home = TRUE
        AND job_title_short = 'Data Analyst'
    GROUP BY skill_id)
SELECT 
    skills_dim.skill_id,
    skills_dim AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 10;


SELECT 
    skills_dim.skills,
    top_skills.skill_count
FROM skills_dim
INNER JOIN(
    SELECT 
        skill_id,    
        COUNT(job_id) AS skill_count
    FROM  skills_job_dim
    GROUP BY skill_id
    ORDER BY COUNT(job_id) DESC
    LIMIT 5
) AS top_skills ON skills_dim.skill_id = top_skills.skill_id
ORDER BY top_skills.skill_count DESC;



SELECT 
    company_id,
    name,
    CASE 
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        WHEN job_count > 10 THEN 'Large'
    END AS company_size
FROM (

    SELECT 
        cd.company_id,
        cd.name,
        COUNT(jb.job_id) AS job_count
    FROM company_dim AS cd
    INNER JOIN job_postings_fact AS jb 
    ON jb.company_id = cd.company_id
    GROUP BY cd.company_id
) 
AS company_job_count;






SELECT 
    name,
    company_avg_salary

FROM
(SELECT 
    cd.name,
    cd.company_id,
    AVG(salary_year_avg) AS company_avg_salary
FROM company_dim AS cd
INNER JOIN job_postings_fact AS jb 
ON jb.company_id = cd.company_id
WHERE jb.salary_year_avg IS NOT NULL
GROUP BY cd.company_id) AS company_salary

WHERE company_salary.company_avg_salary > 
    (SELECT 
    AVG(salary_year_avg) 
    FROM job_postings_fact);


WITH job_offer AS(
SELECT 
    company_id,
    COUNT(DISTINCT job_title) AS num_job
FROM job_postings_fact
GROUP BY company_id)
SELECT 
    cd.name, 
    job_offer.num_job
FROM job_offer 
INNER JOIN company_dim AS cd
ON job_offer.company_id = cd.company_id
ORDER BY job_offer.num_job DESC;


WITH country_avg_salary AS (
SELECT 
    job_country,
    AVG(salary_year_avg) AS country_salary_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
    AND job_country IS NOT NULL
GROUP BY job_country
)
SELECT 
    jb.job_id,
    jb.job_title,
    cd.name AS company_name,
    jb.salary_year_avg AS salary_rate,
    EXTRACT(MONTH FROM job_posted_date) AS posting_month,
    CASE WHEN jb.salary_year_avg > cas.country_salary_avg THEN 'Above average'
    ELSE 'Below average'
    END AS avg_comparison

FROM job_postings_fact AS jb

INNER JOIN company_dim AS cd
ON cd.company_id = jb.company_id
INNER JOIN country_avg_salary AS cas
ON jb.job_country = cas.job_country
WHERE salary_year_avg is NOT NULL
ORDER BY 
    posting_month DESC;


WITH skill_required AS(
SELECT 
    cd.company_id,
    cd.name,
    COUNT(DISTINCT sjd.skill_id) AS skill_count
    
FROM company_dim AS cd
LEFT JOIN job_postings_fact AS jb 
ON cd.company_id = jb.company_id
LEFT JOIN skills_job_dim AS sjd
ON jb.job_id = sjd.job_id
GROUP BY cd.company_id
),

salary_skill AS (
SELECT
    
    jb.company_id,
    MAX(salary_year_avg) AS highest_salary
FROM job_postings_fact AS jb
WHERE jb.job_id IN (SELECT job_id FROM skills_job_dim)
GROUP BY jb.company_id)

SELECT 
    cd.name,
    skill_required.skill_count AS unique_skill_needed,
    salary_skill.highest_salary AS salary
FROM company_dim AS cd
INNER JOIN skill_required ON cd.company_id = skill_required.company_id
INNER JOIN salary_skill ON cd.company_id = salary_skill.company_id 
ORDER BY cd.name ASC


SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs


UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs





SELECT
    q1.job_title_short,
    q1.job_location,
    q1.job_via,
    q1.job_posted_date::DATE,
    q1.salary_year_avg
FROM(
SELECT * 
FROM january_jobs
UNION ALL
SELECT * 
FROM february_jobs 
UNION ALL 
SELECT *
FROM march_jobs
) AS q1
WHERE 
q1.salary_year_avg > 70000
AND q1.job_title_short = 'Data Analyst'
ORDER BY 
    q1.salary_year_avg DESC


SELECT 
    job_id,
    job_title
FROM job_postings_fact
WHERE 
salary_year_avg IS NOT NULL
AND salary_hour_avg IS NOT NULL

UNION ALL

SELECT 
    job_id,
    job_title
FROM job_postings_fact


SELECT
    job_postings_q1.job_id,
    job_postings_q1.job_title_short,
    job_postings_q1.job_location,
    job_postings_q1.job_via,
    job_postings_q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
-- Get job postings from the first quarter of 2023
    (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) as job_postings_q1
LEFT JOIN skills_job_dim ON job_postings_q1.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_q1.salary_year_avg > 70000
ORDER BY
    job_postings_q1.job_id;


SELECT 
    COUNT(jb_q1.job_id) AS jb_count,
    sd.skills


FROM (  SELECT *
        FROM january_jobs
        UNION ALL
        SELECT * 
        FROM february_jobs
        UNION ALL
        SELECT * 
        FROM march_jobs)
    AS  jb_q1

LEFT JOIN skills_job_dim AS sjd 
ON sjd.job_id = jb_q1.job_id
LEFT JOIN skills_dim AS sd 
ON sjd.skill_id = sd.skill_id 
GROUP BY sd.skills
ORDER by jb_count DESC

