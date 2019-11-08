-- ���� ����
-- ���� ��??
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-- EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� 
-- �μ���ȣ�� ���� �ְ�, �μ���ȣ�� ���� dept ���̺�� ������ ����
-- �ش� �μ��� ������ ������ �� �ִ�.

-- ���� ��ȣ, ���� �̸�, ������ �ҼӺμ���ȣ, �μ��̸�
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �μ���ȣ, �μ���, �ش�μ��� �ο���
-- count(col) : col ���� �����ϸ� 1, null :  0
--              ����� �ñ��� ���̸� *

SELECT emp.deptno, dname, count(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

-- TOTAL ROW : 14
select COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
from emp;

-------------------------------------------------------------

-- OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ�����
--              �������� �ϴ� ���� ����
-- LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������
--                  �ǵ��� �ϴ� ���� ����
-- RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������
--                  �ǵ��� �ϴ� ���� ����
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

-- ���� ������, �ش� ������ ������ ���� OUTER JOIN
-- ���� ��ȣ, �����̸�, ������ ��ȣ, ������ �̸�

-- << ANSI LEFT OUTER JOIN>>
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- outer join �� ������
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

-- << ORACLE OUTER JOIN >> (left, right�� ����, fullouter�� �������� ����.
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

-- outer join �� ������
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno;


-- << ANSI LEFT OUTER JOIN>>
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);

-- outer join �� ������
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno = 10;

-- << ORACLE OUTER JOIN >>
-- oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
-- outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

-- outer join �� ������
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno = 10;

-- <<ANSI RIGHT OUTER JOIN >>
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);


-- Q. �����Ͱ��� (�ǽ� outerjoin1) 213p
-- buyprod ���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ�� �ۿ� ����.
-- ��� ǰ���� ���� �� �ֵ��� ������ �ۼ��غ�����.

-- << ANSI LEFT OUTER JOIN>>
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a LEFT OUTER JOIN  buyprod b ON (a.prod_id = b.buy_prod AND b.buy_date = TO_DATE('20050125', 'YYYYMMDD'));

-- << ORACLE OUTER JOIN >>
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. �����Ͱ��� (�ǽ� outerjoin2) 214p
-- outerjoin1���� �۾��� �����ϼ���. buy_date �÷��� null�� �׸��� �ȳ�������
-- ����ó�� �����͸� ä�������� ������ �ۼ��ϼ���.

-- �� Ǯ��
SELECT DECODE(b.buy_date, NULL, TO_DATE('20050125', 'YYYYMMDD'), b.buy_date) buy_date , b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- �� Ǯ��
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. �����Ͱ��� (�ǽ� outerjoin3) 215p
-- outerjoin2���� �۾��� �����ϼ���. buy_qty �÷��� null�� ��� 
-- 0���� ���̵��� ������ �����ϼ���.

-- �� Ǯ��
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, DECODE(b.buy_qty, NULL, 0, b.buy_qty) buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- �� Ǯ��
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, NVL(b.buy_qty, 0)
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. �����Ͱ��� (�ǽ� outerjoin4) 216p
-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
-- ��1�� �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (���� cid=1�� ���� �������� ����, null ó��)

SELECT product.pid, pnm, NVL(cid, 1) cid,  NVL(day, 0) day, NVL(cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+) = product.pid
AND cycle.cid(+) = 1;

-- Q. �����Ͱ��� (�ǽ� outerjoin5) 217p
-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
-- ��1�� �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�Ǹ� ���̸��� �����Ͽ� ������ �ۼ��ϼ���.
-- (���� cid=1�� ���� �������� ����, null ó��)
SELECT a.pid, a.pnm, a.cid, cnm, a.day, a.cnt
FROM
(    SELECT product.pid, pnm, NVL(cid, 1) cid,  NVL(day, 0) day, NVL(cnt, 0) cnt
    FROM cycle, product
    WHERE cycle.pid(+) = product.pid
    AND cycle.cid(+) = 1)a, customer b
WHERE a.cid = b.cid
ORDER BY pid desc, day desc;

-- Q. �����Ͱ��� (�ǽ� crossjoin1) 223p
-- customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ��
-- ������ �����Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

-- subquery : main ������ ���ϴ� �κ� ����
-- ���Ǵ� ��ġ :
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�.)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now/*���糯¥*/ 
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now  -- SELECT �ȿ� �ִ� SELECT������ �ϳ��� �÷��� �����.
FROM emp;



-- WHERE - subquery
SELECT deptno  -- 20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

SELECT *
FROM emp
WHERE deptno = (SELECT deptno  -- 20
                FROM emp
                WHERE ename = 'SMITH');

-- Q. �������� (�ǽ� sub1) 230p
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���.

-- �� Ǯ��
-- �켱 ��� �޿��� ���Ѵ�.
SELECT SUM(sal)/COUNT(empno)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT SUM(sal)/COUNT(empno)
             FROM emp);
            
-- �� Ǯ��
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

-- Q. �������� (�ǽ� sub2) 231p
-- ��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���.

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);



