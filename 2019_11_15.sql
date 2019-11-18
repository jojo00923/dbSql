-- 인덱스 만드는 법
-- UNIQUE 제약으로 인한 자동 생성
-- CREATE INDEX로 직접 생성

-- emp 테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ==> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성


-- << UNIQUE 인덱스 생성  >>
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

-- 인덱스인 empno가 7782인 데이터로 바로 가서 읽음.
SELECT *
FROM TABLE(dbms_xplan.display);

-- empno 컬럼으로 인덱스가 존재하는 상황에서
-- 다른 컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

-- job이 MANAGER인 14개의 데이터를 읽고 나머지 데이터는 버린거야
SELECT *
FROM TABLE(dbms_xplan.display);


-------------------------------------------------------
-- TABLE 생성 (제약조건이 없고 인덱스를 별도로 생성X)
--> TABLE ACCESS FULL

-- 접근 가능한 전략

-- 2. 첫번째 인덱스 
--> TABLE ACCESS FULL
--  첫번째 인덱스

-- 2. 두번째 인덱스 
--> TABLE ACCESS FULL
--  첫번째 인덱스
--  두번째 인덱스

-- 2. 세번째 인덱스 (전략 4개)
--> TABLE ACCESS FULL
--  첫번째 인덱스
--  두번째 인덱스
--  세번째 인덱스

-- 인덱스가 3개일 때,
-- 테이블 2개 조인시 : 16개 전략 가능 (4 * 4)
-- 테이블 3개 조인시 : 64개 전략 가능 (4 * 4 * 4)
-- 테이블 4개 조인시 : 256개 전략 가능 (4 * 4 * 4 * 4)
-----------------------------------------------------

-- 인덱스 구성 컬럼만으로 SELECT절에 기술한 경우
-- 테이블 접근이 필요 없다.

EXPLAIN PLAN FOR
SELECT empno         -- *이 아니라 PK만 가져옴.
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);



-- 컬럼에 중복이 가능한 non-unique 인덱스 생성 후
-- unique index와의 실행계획 비교
-- PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;








-- << NONUNIQUE 인덱스 생성 >>
CREATE /*UNIQUE*/ INDEX IDX_EMP_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- empno값을 기준으로 non-unique인덱스 생성 => empno 값을 기준으로 정렬(기본 오름차순, 옵션을 통해 내림차순도 가능)
-- 정렬이 되어 있어서 7782를 검색하고 7782와 다른 값이 나올때까지만 검색하고 마침
-- |*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |

-- emp 테이블에 job 컬럼으로 두번째 인덱스 생성 (non-unique index)
-- job 컬럼은 다른 로우의 job 컬럼과 중복이 가능한 컬럼이다.
CREATE INDEX idx_emp_02 ON emp(job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);
-- |*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);








-- << emp 테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성 >>
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- ppt 378
-- MANAGER이면서 C로 시작하는 데이터부터 읽음. (MANAGER면서 BLAKE인 데이터는 읽지 않음.) MANAGER들을 다 읽으면(여기선 JONES까지) 끝남. (C로 시작하는 애들이 있을 수 있으니깐.)
------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
------------------------------------------------------------------------------------------







-- << emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성 >>
CREATE INDEX IDX_EMP_04 ON emp (ename, job);

-- 선행 컬럼인 ename이 완벽하게 나오지 않았을 때, 선행컬럼이 완벽하게 나왔을거라고 생각하고 읽음. 인덱스를 다 읽어야해.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE '%C'
AND job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);





-- HINT를 사용한 실행계획 제어

EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_04 ) */ * -- 주석인데  +를 넣으면 개발자가 나한테 명령을 하는구나 하고 적용함. 문법이 잘못되었을 경우는 무시함.
FROM emp
WHERE ename LIKE '%C'
AND job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- Q. DDL (Index 실습 idx1)
-- CREATE TABLE dept_test AS SELECT *FROM dept WHERE 1 = 1 구문으로 dept_test 테이블 생성 후
-- 다음 조건에 맞는 인덱스를 생성하세요.

CREATE TABLE dept_test AS 
SELECT *
FROM dept
WHERE 1 = 1;

-- deptno 컬럼을 기준으로 unique 인덱스 생성
CREATE UNIQUE INDEX idx_emp_test_01
ON dept_test (deptno);

-- dname 컬럼을 기준으로 non_unique 인덱스 생성
CREATE INDEX idx_emp_test_02
ON dept_test (dname);

-- deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX idx_dept_test_03
ON dept_test (deptno, dname);

-- 인덱스명 잘못 적어서 삭제 후 다시 생성
DROP INDEX idx_emp_test_01;
DROP INDEX idx_emp_test_02;
CREATE UNIQUE INDEX idx_dept_test_01
ON dept_test (deptno);
CREATE INDEX idx_dept_test_02
ON dept_test (dname);

-- Q. DDL (Index 실습 idx2)
-- 실습 idx1에서 생성한 인덱스를 삭제하는 DDL문을 작성하세요.
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;
DROP INDEX idx_dept_test_03;

-- Q. DDL (Index 실습 idx3)
-- 시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp 테이블에 
-- 필요하다고 생각되는 인덱스를 생성 스크립트를 만들어 보세요
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7298;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SCOTT';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
AND deptno = 20;

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 10
AND emp.empno LIKE '78%';

EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.
`   



= b.empno
AND a.deptno = 30;

SELECT *
FROM TABLE (dbms_xplan.display);

--------------------
DROP INDEX idx_emp_01; -- nonunique인데 컬럼이 겹쳐서 지움.

-- 나 , 명성이 답
CREATE UNIQUE INDEX idx_emp_05 ON emp (empno);
CREATE UNIQUE INDEX idx_emp_06 ON emp (ename, empno);
CREATE UNIQUE INDEX idx_emp_07 ON emp (deptno, sal, empno);
CREATE UNIQUE INDEX idx_emp_dept_08 ON emp (deptno, empno);
CREATE UNIQUE INDEX idx_emp_emp_09 ON emp (empno, deptno);

-- 쌤 답
CREATE UNIQUE INDEX idx_emp_05 ON emp (empno);
CREATE UNIQUE INDEX idx_emp_06 ON emp (ename);
CREATE UNIQUE INDEX idx_emp_07 ON emp (deptno, sal, empno);
--CREATE UNIQUE INDEX idx_emp_dept_08 ON emp (deptno, empno); 위와 같은 인덱스를 사용
CREATE UNIQUE INDEX idx_emp_emp_09 ON emp (deptno, mgr);

















