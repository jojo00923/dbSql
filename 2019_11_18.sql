SELECT *
FROM USER_VIEWS; -- �ش� ����� ������ ������ �ִ� ��

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC25'; -- �ٸ�����ڷκ��� ������ ���� ����� ����

SELECT *
FROM PC25.V_EMP_DEPT;

-- sem �������� ��ȸ������ ���� V_EMP_DEPT view�� hr �������� ��ȸ�ϱ�
-- ���ؼ��� ������.view�̸� �������� ����� �ؾ��Ѵ�.
-- �Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����.

CREATE SYNONYM V_EMP_DEPT FOR pc25.V_EMP_DEPT;

-- pc25.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- �ó�� ����
DROP SYNONYM V_EMP_DEPT;

-- hr ���� ��й�ȣ : java
-- hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
-- ALTER USER pc25 IDENTIFIED BY java; -- ���� ������ �ƴ϶� ����


-- data dictionary 
-- �ý��� ������ ��ȸ�� �� �ִ� view
-- SELECT * FROM USER_TABLES;
-- ���ξ� : USER : ����� ���� ��ü
--         ALL : ����ڰ� ��밡���� ��ü
--         DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--         V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC25','HR'); -- ���Ƽ� ���� ��. �����ڱ��� �ִ� SYSTEM���������� ����

-- ����Ŭ���� ������ SQL�̶�?
-- ���ڰ� �ϳ��� Ʋ���� �ȵ�
-- ���� SQL���� ���� ����� ����� ���� ���� DBMS������
-- ���� �ٸ� SQL�� �νĵȴ�.
SELECT /*+bind_test*/ * FROM emp;
Select /*+bind_test*/ * FROM emp;
Select /*+bind_test*/ *  FROM emp;

Select /*+bind_test*/ *  FROM emp WHERE empno=7369;
Select /*+bind_test*/ *  FROM emp WHERE empno=7499;
Select /*+bind_test*/ *  FROM emp WHERE empno=7521;

Select /*+bind_test*/ *  FROM emp WHERE empno=:empno;


-- system ���� (dbms���� ������ �� ���� �ִ� ���� ����)
SELECT *
FROM v$SQL;

SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%'; -- ���� �ٸ� �����ȹ�� ������ �� Ȯ���ϱ� ����.

-- ���� ���ε庯���� ���� ������ ���� ������ �����ȹ�� ����� �����̴�.
-- prepared statement�������� ���ʿ��ϰ� dbms�� �����ϸ� ���ֱ� ���ؼ�..

