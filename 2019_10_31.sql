----------------------------------����
-- ���̺��� ������ ��ȸ
/*
    SELECT �÷� : express (���ڿ����) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)

*/

DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' select_query
FROM user_tables
WHERE TABLE_NAME = 'EMP';
--��ü�Ǽ� -1

SELECT *
FROM user_tables;
----------------------------------���� ��

-- ���ں� ����
-- Q) �μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ���� ��ȸ (���̺� emp, �μ���ȣ depno)
SELECT *
FROM emp
WHERE deptno >= 30;

-- Q) �μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

-- Q) �Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ (���̺� emp, �Ի����� hiredate)
SELECT * 
FROM emp
WHERE hiredate < '82/01/01'; --���ڿ��ε� ��� ��¥�� �ν�������? ���� - ���� - �����ͺ��̽� - NLS�� ��¥������ RR/MM/DD�� �Ǿ��־  
--WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD'); -- ���� �̷��� ���°� ����.

-- col BETWEEN X AND Y ����   
-- �÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
-- Q) �޿�(sal)�� 1000���� ũ�ų� ����, Y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- ���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����. (+ �μ���ȣ�� 30)
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 30;

-- Q. �ǽ�1 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ �����
-- ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- (��, �����ڴ� between�� ����Ѵ�.)

SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('82/01/01','RR/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD'); 

-- Q. �ǽ�2 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ �����
-- ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- (��, �����ڴ� �񱳿�����(>=,>,<=,<�� ����Ѵ�.)

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('82/01/01','RR/MM/DD') 
  AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

-- IN ������
-- COL IN (values...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in (10,20);

-- IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
-- Q. �ǽ�3 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- users ���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ�. (���̵�, �̸�, ���� ������)
-- (IN �����ڸ� ����Ѵ�.)

SELECT userid as "���̵�", usernm �̸�, alias ���� 
FROM users
WHERE userid in ('brown','cony','sally'); 


-- COL LIKE 'S%'
-- COL�� ���� �빮�� S�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

-- emp ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%'; -- ����Ŭ���� Ű����� ��ҹ��ڸ� ������ ������ ���� ��ҹ��ڸ� ������.

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- Q. �ǽ�4 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- Q. �ǽ�5 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- NULL ��
-- col IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT * 
FROM emp
WHERE mgr IS NULL;
--WHERE mgr != null; -- null �񱳰� �����Ѵ�.

-- �Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null, is not null

-- Q. �ǽ�6 ) ���ǿ� �´� ������ ��ȸ�ϱ�
-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� �ۼ��Ͻÿ�.
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- ������(mgr) ����� 7698�̰� �޿�(sal)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;

-- ������(mgr) ����� 7698�̰ų� �޿�(sal)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839); 

-- ���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839, NULL); 
-- IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
  AND mgr IS NOT NULL;
  
-- Q. �ǽ�7 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
  
-- Q. �ǽ�8 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
-- (IN, NOT IN ������ ������)
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');

-- Q. �ǽ�9 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
-- (IN, NOT IN ������ ���)
SELECT *
FROM emp
WHERE deptno NOT IN 10
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');

-- Q. �ǽ�10 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
-- (�μ��� 10, 20, 30�� �ִٰ� �����ϰ� IN �����ڸ� ���)
SELECT *
FROM emp
WHERE deptno IN (20,30)
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');
  
-- Q. �ǽ�11 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT * 
FROM emp
WHERE job = 'SALESMAN' -- job IN('SALESMAN')�� ����.
   OR hiredate >= TO_DATE('19810601','YYYYMMDD');
  
-- Q. �ǽ�12 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
