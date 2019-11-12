SELECT *
FROM dept;

DELETE dept
WHERE deptno = 99;
COMMIT;

INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');
-----------------------------------------------
-- << DML >>

desc emp;

-- 연습 1
INSERT INTO emp(empno, ename, job)
VALUES (9999,'brown', ''); -- null, ""입력 가능

SELECT *
FROM emp
WHERE empno=9999;

-- not null인 컬럼인 경우 생략 불가
-- cannot insert NULL into ("PC25"."EMP"."EMPNO")
INSERT INTO emp(ename, job)
VALUES ('brown', ''); 

rollback; -- 취소


-- 연습 2
desc emp;

-- 오라클에서 제공하는 것.
SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- 찾고 싶은 테이블을 대문자로 적어준다.
ORDER BY column_id;
/*
EMPNO
ENAME
JOB
MGR
HIREDATE
SAL
COMM -- 상여
DEPTNO
*/

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

SELECT *
FROM emp;

commit;

-- SELECT 결과(여러건)를 INSERT


INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

-- UPDATE
-- UPDATE 테이블 SET 컬럼 = 값, 컬럼 = 값...
-- WHERE condition

UPDATE dept SET dname='대덕IT', loc='ym' -- 한글 하나당 3바이트
WHERE deptno = 99;

SELECT *
FROM dept;


-- DELETE 테이블명
-- WHERE condition
-- 사원번호가 9999인 직원을 emp 테이블에서 삭제

SELECT *
FROM emp;

DELETE emp
WHERE empno = 9999;



-- 부서 테이블을 이용해서 emp 테이블에 입력한 5건의 데이터를 삭제
-- 10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;
--또는
DELETE emp
WHERE empno BETWEEN 10 AND 99;
--또는
DELETE emp
WHERE empno IN(SELECT deptno FROM dept);

-- 삭제하기 전 삭제할 데이터 확인
SELECT *
FROM emp
WHERE empno < 100;
-- 또는
select *
from emp
WHERE empno IN(SELECT deptno FROM dept);

COMMIT;

rollback;

SELECT *
FROM dept;

-- LV1 --> LV3(상대방이 커밋한게 안보임)
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

-- DML문장을 통해 트랜잭션 시작
INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');

-- LV1(기본)
SET TRANSACTION
isolation LEVEL READ COMMITTED;

-- << DDL >>
-- AUTO COMMIT, ROLLBACK이 안됨.
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,               -- 숫자 타입
    ranger_name VARCHAR2(50),       --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate     -- DEFAULT : SYSDATE 
);

DESC ranger;

-- ddl은 rollback이 적용되지 않는다.
rollback;

-- 만든 테이블에 데이터를 넣어준다.
INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
commit;


-- 날짜 타입에서 특정 필드 가져오기
-- ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,
    TO_CHAR(reg_dt, 'MM'),
    EXTRACT(MONTH FROM reg_dt) mm,
    EXTRACT(YEAR FROM reg_dt) year,
    EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;



-- 제약조건
-- DEPT 모방해서 DEPT_TEST 생성
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,   -- deptno 컬럼을 식별자로 지정
    dname varchar2(14),             -- 식별자로 지정이 되면 값이 중복이 될 수 없으며, null일수도 없다.
    loc varchar2(13)
);

-- primary key 제약 조건 확인
-- 1. deptno컬럼에 null이 들어갈 수 없다.
-- 2. deptno컬럼에 중복된 값이 들어갈 수 없다.

-- null 테스트
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

-- 중복값 테스트
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

rollback;

-- 사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

-- TABLE CONSTRAINT 
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

-- 중복값 테스트(둘다 insert가능)
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT *
FROM dept_test;
rollback;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');



-- UNIQUE

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');
rollback;








