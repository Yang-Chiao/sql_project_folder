SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    --AND job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC

/*SVN (Subversion) surprisingly tops the list at $400,000, likely due to niche demand and legacy system expertise.

Solidity, essential for smart contract development on Ethereum, offers $179,000, reflecting the blockchain industry's growth.

Data science & AI tools like Couchbase, DataRobot, and MXNet show strong six-figure salaries, suggesting demand for scalable ML/AI infrastructure.

Skills like Terraform and VMware highlight high-value in DevOps and infrastructure management roles.*/