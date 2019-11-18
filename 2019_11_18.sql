SELECT *
FROM USER_VIEWS; -- 해당 사용자 계정이 가지고 있는 뷰

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC25'; -- 다른사용자로부터 권한을 받은 뷰까지 포함

SELECT *
FROM PC25.V_EMP_DEPT;

-- sem 계정에서 조회권한을 받은 V_EMP_DEPT view를 hr 계정에서 조회하기
-- 위해서는 계정명.view이름 형식으로 기술을 해야한다.
-- 매번 계정명을 기술하기 귀찮으므로 시노님을 통해 다른 별칭을 생성.

CREATE SYNONYM V_EMP_DEPT FOR pc25.V_EMP_DEPT;

-- pc25.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- 시노님 삭제
DROP SYNONYM V_EMP_DEPT;

-- hr 계정 비밀번호 : java
-- hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
-- ALTER USER pc25 IDENTIFIED BY java; -- 본인 계정이 아니라 에러


-- data dictionary 
-- 시스템 정보를 조회할 수 있는 view
-- SELECT * FROM USER_TABLES;
-- 접두어 : USER : 사용자 소유 객체
--         ALL : 사용자가 사용가능한 객체
--         DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
--         V$ : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC25','HR'); -- 많아서 조건 줌. 관리자권한 있는 SYSTEM계정에서만 가능

-- 오라클에서 동일한 SQL이란?
-- 문자가 하나라도 틀리면 안됨
-- 다음 SQL들은 같은 결과를 만들어 낼지 몰라도 DBMS에서는
-- 서로 다른 SQL로 인식된다.
SELECT /*+bind_test*/ * FROM emp;
Select /*+bind_test*/ * FROM emp;
Select /*+bind_test*/ *  FROM emp;

Select /*+bind_test*/ *  FROM emp WHERE empno=7369;
Select /*+bind_test*/ *  FROM emp WHERE empno=7499;
Select /*+bind_test*/ *  FROM emp WHERE empno=7521;

Select /*+bind_test*/ *  FROM emp WHERE empno=:empno;


-- system 계정 (dbms에서 실행이 된 적이 있는 쿼리 모음)
SELECT *
FROM v$SQL;

SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%'; -- 서로 다른 실행계획이 세워진 걸 확인하기 위함.

-- 따라서 바인드변수를 쓰는 이유는 같은 쿼리로 실행계획을 세우기 위함이다.
-- prepared statement쓰는이유 불필요하게 dbms에 과부하를 안주기 위해서..

