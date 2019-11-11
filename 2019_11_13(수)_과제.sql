-- join 8
-- erd ���̾�׷��� �����Ͽ� countries, regions ���̺��� �̿��Ͽ�
-- ������ �Ҽ� ������ ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ ������ ����)
SELECT r.region_id, region_name, country_name
FROM regions r, countries c
WHERE r.region_id = c.region_id
AND region_name = 'Europe';

-- join 9
-- erd ���̾�׷��� �����Ͽ� countries, regions, locations ���̺���
-- �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸��� ������ ����
-- ����� �������� ������ �ۼ��غ�����.
-- (������ ������ ����)
SELECT r.region_id, region_name, country_name, city
FROM regions r, countries c, locations l
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND region_name = 'Europe';

-- join 10
-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departments ���̺���
-- �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ� �μ���
-- ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ ������ ����)
SELECT r.region_id, region_name, country_name, city, department_name
FROM countries c, regions r, locations l, departments d
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND region_name = 'Europe';

-- join 11
-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departments, employees
-- ���̺��� �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ� �μ�, �μ���
-- �Ҽӵ� ���� ������ ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ ������ ����)
SELECT r.region_id, region_name, country_name, city, department_name, first_name || last_name name
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND l.location_id = d.location_id
AND d.department_id = e.department_id
AND region_name = 'Europe';

-- join 12
-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������ ������ ��Ī��
-- �����Ͽ� ������ ���� ����� �������� ������ �ۼ��غ�����.
SELECT employee_id, first_name || last_name AS name, j.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

-- join 13
-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������
-- ������ ��Ī, ������ �Ŵ��� ���� �����Ͽ� ������ ���� ����� ��������
-- ������ �ۼ��غ�����.
SELECT manager_id mng_id, (SELECT first_name || last_name mgr_name FROM employees WHERE employee_id = 100) mgr_name, employee_id, first_name || last_name name, j.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
AND manager_id = 100
AND employee_id >= 120
ORDER BY employee_id;







