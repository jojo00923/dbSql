-- join 8
-- erd 다이어그램을 참고하여 countries, regions 테이블을 이용하여
-- 지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (지역은 유럽만 한정)
SELECT r.region_id, region_name, country_name
FROM regions r, countries c
WHERE r.region_id = c.region_id
AND region_name = 'Europe';

-- join 9
-- erd 다이어그램을 참고하여 countries, regions, locations 테이블을
-- 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은
-- 결과가 나오도록 쿼리를 작성해보세요.
-- (지역은 유럽만 한정)
SELECT r.region_id, region_name, country_name, city
FROM regions r, countries c, locations l
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND region_name = 'Europe';

-- join 10
-- erd 다이어그램을 참고하여 countries, regions, locations, departments 테이블을
-- 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를
-- 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (지역은 유럽만 한정)
SELECT r.region_id, region_name, country_name, city, department_name
FROM countries c, regions r, locations l, departments d
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND region_name = 'Europe';

-- join 11
-- erd 다이어그램을 참고하여 countries, regions, locations, departments, employees
-- 테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에
-- 소속된 직원 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (지역은 유럽만 한정)
SELECT r.region_id, region_name, country_name, city, department_name, first_name || last_name name
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND d.department_id = e.department_id
AND region_name = 'Europe';

-- join 12
-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭을
-- 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT employee_id, first_name || last_name AS name, j.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

-- join 13
-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
-- 담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록
-- 쿼리를 작성해보세요.
SELECT manager_id mng_id, (SELECT first_name || last_name mgr_name FROM employees WHERE employee_id = 100) mgr_name, employee_id, first_name || last_name name, j.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
AND manager_id = 100
AND employee_id >= 120
ORDER BY employee_id;







