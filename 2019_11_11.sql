--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (10,20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN ('SMITH','WARD'));
                 
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1,:name2)); --- �����

---------------------------------------------------------------------                 
-- << ANY >> : SET �߿� �����ϴ°� �ϳ��� ������ ������ (ũ�� ��)
-- SMITH �Ǵ� WARD�� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ

-- SMITH�� WARD�� �޿�
SELECT sal -- 800, 1250
FROM emp
WHERE ename IN ('SMITH','WARD');
                 
-- SMITH �Ǵ� WARD�� �޿����� ���� �޿��� �޴� ���� ����         
SELECT *
FROM emp
WHERE sal < any( SELECT sal 
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));
-- << ALL >>                 
-- SMITH�� WARD�� �޿����� ���� �޿��� �޴� ���� ����   
-- SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal < all( SELECT sal 
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));

-- << IN >>

-- �������� ��������
-- 1. �������� ����� ��ȸ
-- . mgr �÷��� ���� ������ ����
SELECT DISTINCT(mgr)
FROM emp;

-- � ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839,7782,7698,7902,7566,7788);
-- KING - JONES - SCOTT
SELECT *
FROM emp
WHERE empno IN (SELECT DISTINCT(mgr)
                FROM emp);

-- << NOT IN >>
-- ������ ������ ���� �ʴ� ���� ���� ��ȸ
-- �� NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                FROM emp
                WHERE mgr IS NOT NULL);                

SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                FROM emp
                WHERE mgr IS NOT NULL);                
                 
-- << PAIR WISE >>
-- ��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- 7698 30
-- 7839 10
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

-- ���� �߿� �����ڿ� �μ���ȣ�� (7698,30) �̰ų�, (7839,10)�� ���
-- mgr, deptno �÷��� ���ÿ� ������Ű�� �������� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));

-- mgr, deptno �÷��� ���� ������Ű�� �������� ��ȸ
-- 7698 30
-- 7839 10
-- (7698, 30), (7698, 10), (7839, 30), (7839,10)
-- (7698, 30) , ~
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499,7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499,7782));

-- �Ʒ��� ���� ����.
SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
AND deptno IN (10, 30);            

-- SCALAR SUBQUERY : SELECT���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, '�μ���' dname -- ?? ���� �ʿ�
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

-- Q. �������� (�ǽ� sub4) 246p
-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����
-- ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��ϼ���.

-- ��ü ��ȸ
SELECT *
FROM dept;

-- ������ ����
INSERT INTO dept VALUES (99,'ddit', 'daejeon');
COMMIT;

-- �� Ǯ��
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE deptno IS NOT NULL);
                 
-- Q. �������� (�ǽ� sub5) 247p
-- cycle, product ���̺��� �̿��Ͽ� cid=1�� ���� �������� 
-- �ʴ� ��ǰ�� ��ȸ�ϴ� ������ �ۼ��ϼ���.

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

-- Q. �������� (�ǽ� sub6) 248p
-- cycle ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ ��
-- cid=1�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���.

SELECT *
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cid = 1;
  
------------------------------------------------------------------------------------------------------------------------------------------------------ 
-- ����  
-- Q. �������� (�ǽ� sub7) 249p
-- cycle, product ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ ��
-- cid=1�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϰ� ����� ��ǰ����� �����ϴ� ������ �ۼ��ϼ���.  

-- scalar subquery
SELECT cid, (select cnm from customer where cid = cycle.cid) cnm, pid, (select pnm from product where pid = cycle.pid) pnm, day, cnt
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cid = 1;
-- join 
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM cycle, customer, product
WHERE cycle.pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cycle.cid = 1
  AND cycle.cid = customer.cid
  AND cycle.pid = product.pid;
------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXISTS : MAIN ������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
-- �����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������
-- ���ɸ鿡�� ����

-- MGR�� �����ϴ� ���� ��ȸ -- ���� �ʿ�
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'f'
              FROM emp
              WHERE empno = a.mgr);
              
-- MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' 
              FROM emp
              WHERE empno = a.mgr);
                 
-- Q. �������� (EXISTS������ - �ǽ� sub8) 251p
-- �Ʒ� ������ subquery�� ������� �ʰ� �ۼ��ϼ���.                   

-- MGR�� �����ϴ� ���� ��ȸ ( ��Ǯ��)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)

-- �̷��� ���;���
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

-- �� Ǯ��, �� Ǯ��
SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = dept.deptno);

-- IN���� �����غ���
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);                 
                 
------------------------------------------------------------------------------------------------------------------------------------------------------                 
-- ����
-- Q. �������� (EXISTS������ - �ǽ� sub9) 252p
-- cycle, product ���̺��� �̿��Ͽ� cid=1�� ���� �������� �ʴ� ��ǰ��
-- ��ȸ�ϴ� ������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���.

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

SELECT *
FROM product
WHERE NOT EXISTS(SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND pid = product.pid);
------------------------------------------------------------------------------------------------------------------------------------------------------
                  
-- ���տ���
-- << UNION >>      : ���� �ΰ��� ��ħ. ������, �ߺ��� ����
--                  DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--                  (�뷮�� �����Ϳ� ���� ���Ľ� ����)
-- << UNION ALL >>  : UNION�� ���� ����
--                  �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� --> �ߺ� ����
--                  ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--                  UNION �����ں��� ���ɸ鿡�� ����
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)

-- UNION 
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION

-- ����� 7369 �Ǵ� 7499�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

-- UNION ALL 

-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;

-- INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
-- ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);




SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC25'
AND TABLE_NAME IN ('PROD','LPROD')
AND CONSTRAINT_TYPE IN ('P','R');
















                 
                 