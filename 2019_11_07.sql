------------------����---------------------
-- emp ���̺��� �μ���ȣ(deptno)�� ����
-- emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
-- dept ���̺�� ������ ���� �μ��� ��ȸ

-- ���� ���� 
-- ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
--        emp JOIN dept 0N (emp.deptno = dept.deptno)
-- ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.col = ���̺�2.col
--          FROM emp, dept WHERE emp.deptno = dept.deptno

-- �����ȣ, �����, �μ���ȣ, �μ���
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

------------------------------------------------------------------
-- Q. �����Ͱ��� (�ǽ� join0_2) 182p
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�)

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500;

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal > 2500;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500;

SELECT emp.empno, emp.ename, emp.sal, deptno, dept.dname
FROM emp JOIN dept USING(deptno)
WHERE sal > 2500;

-- Q. �����Ͱ��� (�ǽ� join0_3) 183p
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�, ����� 7600���� ū ����)
SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
  AND empno > 7600;

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
  AND emp.empno > 7600;

-- Q. �����Ͱ��� (�ǽ� join0_4) 184p
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
  AND emp.empno > 7600
  AND dept.dname = 'RESEARCH'
ORDER BY empno desc;

SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH'
ORDER BY empno desc;

-- Q. �����Ͱ��� (�ǽ� join1) 185p
-- erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� �����Ͽ�
-- ������ ���� ����� ������ ������ �ۼ��غ�����.

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod , lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);

-- ���� �÷����� ��� natural join, JOIN USING �� �� �� ����.

-- Q. �����Ͱ��� (�ǽ� join2) 186p
-- erd ���̾�׷��� �����Ͽ� buyer, prod ���̺��� �����Ͽ�
-- buyer�� ����ϴ� ��ǰ ������ ������ ���� ����� �������� ������ �ۼ��غ�����.

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer.buyer_id = prod.prod_buyer);

-- Q. �����Ͱ��� (�ǽ� join3) 187p
-- erd ���̾�׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ�
-- ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ������ ���� ����� �������� ������ �ۼ��غ�����.

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;
  
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member) JOIN prod ON (cart.cart_prod = prod.prod_id);

-- Q. �����Ͱ��� (�ǽ� join4) 188-9p
-- erd ���̾�׷��� �����Ͽ� customer,cycle ���̺��� �����Ͽ�
-- ���� ���� ��ǰ, ���� ����, ������ ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ brown, sally�� ���� ��ȸ)

SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm in ('brown','sally');

SELECT customer.cid, cnm, pid, day, cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
AND cnm in ('brown','sally');

SELECT cid, cnm, pid, day, cnt
FROM customer NATURAL JOIN cycle
WHERE cnm in ('brown','sally');

SELECT cid, cnm, pid, day, cnt
FROM customer JOIN cycle USING(cid)
WHERE cnm in ('brown','sally');


-- Q. �����Ͱ��� (�ǽ� join5) 190p
-- erd ���̾�׷��� �����Ͽ� customer,cycle,product ���̺��� �����Ͽ�
-- ���� ���� ��ǰ, ���� ����, ����, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ brown, sally�� ���� ��ȸ)

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
 AND cnm IN ('brown','sally');

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) JOIN product ON (cycle.pid = product.pid)
WHERE cnm IN ('brown','sally');

-- Q. �����Ͱ��� (�ǽ� join6) 191p
-- erd ���̾�׷��� �����Ͽ� customer,cycle,product ���̺��� �����Ͽ� �������ϰ� �������
-- ���� ���� ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����.
-- (������ brown, sally�� ���� ��ȸ)

-- ���� Ǭ ��
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, sum(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
GROUP BY cycle.cid, customer.cnm,cycle.pid, product.pnm;

-- �� Ǯ��
-- ��, ��ǰ�� �����Ǽ� (���ϰ� �������)
-- Ǯ��1
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid, cnm, product.pid, cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
AND cycle_groupby.pid = product.pid;

-- Ǯ��2
SELECT customer.cid, cnm, product.pid, cnt
FROM (  
        SELECT cid, pid, SUM(cnt) cnt
        FROM cycle
        GROUP BY cid, pid) cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
AND cycle_groupby.pid = product.pid;

-- Ǯ��3
SELECT customer.cid, cnm, product.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, product.pid, pnm;


-- Q. �����Ͱ��� (�ǽ� join7) 192p
-- erd ���̾�׷��� �����Ͽ� cycle,product ���̺��� �����Ͽ� 
-- ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����.

SELECT product.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, pnm
ORDER BY product.pid, pnm ;














drop table batch;
drop table daily;
drop table cycle;
drop table product;
drop table customer;
/* �� */
CREATE TABLE CUSTOMER (
	CID NUMBER NOT NULL, /* ����ȣ */
	CNM VARCHAR2(50) NOT NULL /* ���� */
);

COMMENT ON TABLE CUSTOMER IS '��';

COMMENT ON COLUMN CUSTOMER.CID IS '����ȣ';

COMMENT ON COLUMN CUSTOMER.CNM IS '����';

CREATE UNIQUE INDEX PK_CUSTOMER
	ON CUSTOMER (
		CID ASC
	);

ALTER TABLE CUSTOMER
	ADD
		CONSTRAINT PK_CUSTOMER
		PRIMARY KEY (
			CID
		);

/* ��ǰ */
CREATE TABLE PRODUCT (
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	PNM VARCHAR2(50) NOT NULL /* ��ǰ�� */
);

COMMENT ON TABLE PRODUCT IS '��ǰ';

COMMENT ON COLUMN PRODUCT.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN PRODUCT.PNM IS '��ǰ��';

CREATE UNIQUE INDEX PK_PRODUCT
	ON PRODUCT (
		PID ASC
	);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT PK_PRODUCT
		PRIMARY KEY (
			PID
		);

/* �������ֱ� */
CREATE TABLE CYCLE (
	CID NUMBER NOT NULL, /* ����ȣ */
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	DAY NUMBER NOT NULL, /* ���� */
	CNT NUMBER NOT NULL /* ���� */
);

COMMENT ON TABLE CYCLE IS '�������ֱ�';

COMMENT ON COLUMN CYCLE.CID IS '����ȣ';

COMMENT ON COLUMN CYCLE.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN CYCLE.DAY IS '����';

COMMENT ON COLUMN CYCLE.CNT IS '����';

CREATE UNIQUE INDEX PK_CYCLE
	ON CYCLE (
		CID ASC,
		PID ASC,
		DAY ASC
	);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT PK_CYCLE
		PRIMARY KEY (
			CID,
			PID,
			DAY
		);

/* �Ͻ��� */
CREATE TABLE DAILY (
	CID NUMBER NOT NULL, /* ����ȣ */
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	DT VARCHAR2(8) NOT NULL, /* ���� */
	CNT NUMBER NOT NULL /* ���� */
);

COMMENT ON TABLE DAILY IS '�Ͻ���';

COMMENT ON COLUMN DAILY.CID IS '����ȣ';

COMMENT ON COLUMN DAILY.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN DAILY.DT IS '����';

COMMENT ON COLUMN DAILY.CNT IS '����';

CREATE UNIQUE INDEX PK_DAILY
	ON DAILY (
		CID ASC,
		PID ASC,
		DT ASC
	);

ALTER TABLE DAILY
	ADD
		CONSTRAINT PK_DAILY
		PRIMARY KEY (
			CID,
			PID,
			DT
		);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT FK_CUSTOMER_TO_CYCLE
		FOREIGN KEY (
			CID
		)
		REFERENCES CUSTOMER (
			CID
		);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT FK_PRODUCT_TO_CYCLE
		FOREIGN KEY (
			PID
		)
		REFERENCES PRODUCT (
			PID
		);

ALTER TABLE DAILY
	ADD
		CONSTRAINT FK_CUSTOMER_TO_DAILY
		FOREIGN KEY (
			CID
		)
		REFERENCES CUSTOMER (
			CID
		);

ALTER TABLE DAILY
	ADD
		CONSTRAINT FK_PRODUCT_TO_DAILY
		FOREIGN KEY (
			PID
		)
		REFERENCES PRODUCT (
			PID
		);


/* ��ġ */
CREATE TABLE BATCH (
	BID NUMBER NOT NULL, /* ��ġ��ȣ */
	BCD VARCHAR2(20) NOT NULL, /* ��ġ�۾� */
	ST VARCHAR2(20) NOT NULL, /* ��ġ���� */
	ST_DT DATE, /* ��ġ�������� */
	ED_DT DATE /* ��ġ�������� */
);

COMMENT ON TABLE BATCH IS '��ġ';

COMMENT ON COLUMN BATCH.BID IS '��ġ��ȣ';

COMMENT ON COLUMN BATCH.BCD IS '��ġ�۾�';

COMMENT ON COLUMN BATCH.ST IS '��ġ����';

COMMENT ON COLUMN BATCH.ST_DT IS '��ġ��������';

COMMENT ON COLUMN BATCH.ED_DT IS '��ġ��������';

CREATE UNIQUE INDEX PK_BATCH
	ON BATCH (
		BID ASC
	);

ALTER TABLE BATCH
	ADD
		CONSTRAINT PK_BATCH
		PRIMARY KEY (
			BID
		);        

--�ڷ�        
insert into customer values (1, 'brown');
insert into customer values (2, 'sally');
insert into customer values (3, 'cony');


insert into product values (100, '����Ʈ');
insert into product values (200, '��');
insert into product values (300, '���۽�');
insert into product values (400, '����Ʈ400');

insert into cycle values (1, 100, 2, 1);
insert into cycle values (1, 400, 3, 1);
insert into cycle values (1, 100, 4, 1);
insert into cycle values (1, 400, 5, 1);
insert into cycle values (1, 100, 6, 1);

insert into cycle values (2, 200, 2, 2);
insert into cycle values (2, 100, 3, 1);
insert into cycle values (2, 200, 4, 2);
insert into cycle values (2, 100, 5, 1);
insert into cycle values (2, 200, 6, 2);

insert into cycle values (3, 300, 2, 1);
insert into cycle values (3, 100, 3, 2);
insert into cycle values (3, 300, 4, 1);
insert into cycle values (3, 100, 5, 2);
insert into cycle values (3, 300, 6, 1);

commit;

