-- ����
-- �׷��Լ�
-- multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����


-- ���� �� ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ��� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--------------------------------------------------------------------------------------------------------------------
-- Q. group function �ǽ� grp3 161p
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
    - �μ����� ������ ���� ���� �޿�
    - �μ����� ������ ���� ���� �޿�
    - �μ����� ������ �޿� ���
    - �μ����� ������ �޿� ��
    - �μ��� ������ �޿��� �ִ� ������ ��(NULL����)
    - �μ��� ������ ����ڰ� �ִ� ������ ��(NULL����)
    - �μ��� ��ü ������ ��
*/
-- ���� Ǭ ��


-- �� ��


-- Q. group function �ǽ� grp4 162p
-- emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���.



-- Q. group function �ǽ� grp5 163p
-- emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���.


-- Q. group function �ǽ� grp6 164p
-- ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�. (dept���̺� ���)



-- diptno �÷����� �ߺ��� �����ϴ� ��. ���⿡���� �μ��� 40���� ��� ���� ����.
SELECT distinct deptno
FROM emp;

-- JOIN
-- emp ���̺��� dname �÷��� ����. --> �μ���ȣ(deptno)�ۿ� ����.
desc emp;

-- emp���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
*/
-- emp���̺� dname �÷��� ������ ����
UPDATE emp SET dname ='ACCOUNTING' WHERE deptno=10;
UPDATE emp SET dname ='RESEARCH' WHERE deptno=20;
UPDATE emp SET dname ='SALES' WHERE deptno=30;
commit;

-- �̷��� �ؼ� deptno�� decode�߾��µ�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

-- dname �÷��� ���ܼ� ���� �̷��Ը� ���ָ� ��.
SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

-- dname �÷��� ������.
ALTER TABLE emp DROP COLUMN dname;
commit;

-- ansi natural join : �����ϴ� ���̺��� �÷����� ���� �÷��� �������� JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ���̺� ��Ī�� �༭ ����� ���� �ִ�.
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

-- ORACLE join
-- from ���� ���� ��� ���̺� ����
-- where���� �������� ���
-- ������ ����ϴ� ���� ���൵ ��� ����
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; -- job�� SALESMAN�� ����� ������� ��ȸ
  
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno; -- where �ȿ� ������ �ٲ� �� �۵���.

-- JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF join : ���� ���̺��� ���� ppt 176p
-- emp ���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
-- a : ���� ����, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno) -- a�� mgr������ b�� empno�� �������, �׷��� KING�� mgr�� ��� ����.
WHERE a.empno BETWEEN 7369 AND 7698;

-- SELT join ���ø� Oracle join���� �����غ���.
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno BETWEEN 7369 AND 7698;

-- non-equi joing (��� ������ �ƴ� ���) 177p
SELECT *
FROM salgrade; -- sal�� ���

-- ������ �޿� �����?(non-equijoin)


-- ������ �޿� �����?(JOIN with ON����)


-- non-equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno = 7369; -- mgr�� 7369�� ������ �ϳ� ���� ���ͼ� 13�� ����.

-- non-equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369; -- join������ ������� �ʾ� b���̺��� ��� �÷� ���ͼ� 14�� ����.(Partition product, ������join)

-- Q. �����Ͱ��� (�ǽ� join0) 180p
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.


-- Q. �����Ͱ��� (�ǽ� join0_1) 181p
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�μ���ȣ�� 10, 30�� �����͸� ��ȸ)
