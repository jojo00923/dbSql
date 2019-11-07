------------------복습---------------------
-- emp 테이블에는 부서번호(deptno)만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는
-- dept 테이블과 조인을 통해 부서명 조회

-- 조인 문법 
-- ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
--        emp JOIN dept 0N (emp.deptno = dept.deptno)
-- ORACLE : FROM 테이블, 테이블2 WHERE 테이블.col = 테이블2.col
--          FROM emp, dept WHERE emp.deptno = dept.deptno

-- 사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

------------------------------------------------------------------
-- Q. 데이터결합 (실습 join0_2) 182p
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과)

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

-- Q. 데이터결합 (실습 join0_3) 183p
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과, 사번이 7600보다 큰 직원)
SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
  AND empno > 7600;

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
  AND emp.empno > 7600;

-- Q. 데이터결합 (실습 join0_4) 184p
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원)

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

-- Q. 데이터결합 (실습 join1) 185p
-- erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여
-- 다음과 같은 결과가 나오는 쿼리를 작성해보세요.

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod , lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);

-- 같은 컬럼명이 없어서 natural join, JOIN USING 은 쓸 수 없음.

-- Q. 데이터결합 (실습 join2) 186p
-- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여
-- buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer.buyer_id = prod.prod_buyer);

-- Q. 데이터결합 (실습 join3) 187p
-- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여
-- 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;
  
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member) JOIN prod ON (cart.cart_prod = prod.prod_id);

-- Q. 데이터결합 (실습 join4) 188-9p
-- erd 다이어그램을 참고하여 customer,cycle 테이블을 조인하여
-- 고객별 애음 제품, 애음 요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (고객명이 brown, sally인 고객만 조회)

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


-- Q. 데이터결합 (실습 join5) 190p
-- erd 다이어그램을 참고하여 customer,cycle,product 테이블을 조인하여
-- 고객별 애음 제품, 애음 요일, 개수, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (고객명이 brown, sally인 고객만 조회)

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
 AND cnm IN ('brown','sally');

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) JOIN product ON (cycle.pid = product.pid)
WHERE cnm IN ('brown','sally');

-- Q. 데이터결합 (실습 join6) 191p
-- erd 다이어그램을 참고하여 customer,cycle,product 테이블을 조인하여 애음요일과 관계없이
-- 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- (고객명이 brown, sally인 고객만 조회)

-- 내가 푼 것
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, sum(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
GROUP BY cycle.cid, customer.cnm,cycle.pid, product.pnm;

-- 쌤 풀이
-- 고객, 제품별 애음건수 (요일과 관계없이)
-- 풀이1
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid, cnm, product.pid, cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
AND cycle_groupby.pid = product.pid;

-- 풀이2
SELECT customer.cid, cnm, product.pid, cnt
FROM (  
        SELECT cid, pid, SUM(cnt) cnt
        FROM cycle
        GROUP BY cid, pid) cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
AND cycle_groupby.pid = product.pid;

-- 풀이3
SELECT customer.cid, cnm, product.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, product.pid, pnm;


-- Q. 데이터결합 (실습 join7) 192p
-- erd 다이어그램을 참고하여 cycle,product 테이블을 조인하여 
-- 제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

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
/* 고객 */
CREATE TABLE CUSTOMER (
	CID NUMBER NOT NULL, /* 고객번호 */
	CNM VARCHAR2(50) NOT NULL /* 고객명 */
);

COMMENT ON TABLE CUSTOMER IS '고객';

COMMENT ON COLUMN CUSTOMER.CID IS '고객번호';

COMMENT ON COLUMN CUSTOMER.CNM IS '고객명';

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

/* 제품 */
CREATE TABLE PRODUCT (
	PID NUMBER NOT NULL, /* 제품번호 */
	PNM VARCHAR2(50) NOT NULL /* 제품명 */
);

COMMENT ON TABLE PRODUCT IS '제품';

COMMENT ON COLUMN PRODUCT.PID IS '제품번호';

COMMENT ON COLUMN PRODUCT.PNM IS '제품명';

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

/* 고객애음주기 */
CREATE TABLE CYCLE (
	CID NUMBER NOT NULL, /* 고객번호 */
	PID NUMBER NOT NULL, /* 제품번호 */
	DAY NUMBER NOT NULL, /* 요일 */
	CNT NUMBER NOT NULL /* 수량 */
);

COMMENT ON TABLE CYCLE IS '고객애음주기';

COMMENT ON COLUMN CYCLE.CID IS '고객번호';

COMMENT ON COLUMN CYCLE.PID IS '제품번호';

COMMENT ON COLUMN CYCLE.DAY IS '요일';

COMMENT ON COLUMN CYCLE.CNT IS '수량';

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

/* 일실적 */
CREATE TABLE DAILY (
	CID NUMBER NOT NULL, /* 고객번호 */
	PID NUMBER NOT NULL, /* 제품번호 */
	DT VARCHAR2(8) NOT NULL, /* 일자 */
	CNT NUMBER NOT NULL /* 수량 */
);

COMMENT ON TABLE DAILY IS '일실적';

COMMENT ON COLUMN DAILY.CID IS '고객번호';

COMMENT ON COLUMN DAILY.PID IS '제품번호';

COMMENT ON COLUMN DAILY.DT IS '일자';

COMMENT ON COLUMN DAILY.CNT IS '수량';

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


/* 배치 */
CREATE TABLE BATCH (
	BID NUMBER NOT NULL, /* 배치번호 */
	BCD VARCHAR2(20) NOT NULL, /* 배치작업 */
	ST VARCHAR2(20) NOT NULL, /* 배치상태 */
	ST_DT DATE, /* 배치시작일자 */
	ED_DT DATE /* 배치종료일자 */
);

COMMENT ON TABLE BATCH IS '배치';

COMMENT ON COLUMN BATCH.BID IS '배치번호';

COMMENT ON COLUMN BATCH.BCD IS '배치작업';

COMMENT ON COLUMN BATCH.ST IS '배치상태';

COMMENT ON COLUMN BATCH.ST_DT IS '배치시작일자';

COMMENT ON COLUMN BATCH.ED_DT IS '배치종료일자';

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

--자료        
insert into customer values (1, 'brown');
insert into customer values (2, 'sally');
insert into customer values (3, 'cony');


insert into product values (100, '야쿠르트');
insert into product values (200, '윌');
insert into product values (300, '쿠퍼스');
insert into product values (400, '야쿠르트400');

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

