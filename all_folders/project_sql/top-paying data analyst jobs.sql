/*Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type
FROM job_postings_fact
where job_title_short = 'Data Analyst'
