-- SELECT : 조회할 컬럼을 명시
--        - 전체 컬럼 조회 : *
--        - 일부 컬럼 : 해당 컬럼명 나열 (,구분)
-- FROM : 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관 없다.
-- 단 keyword는 붙여서 작성

-- 모든 컬럼을 조회
SELECT * FROM prod;

-- 특정 컬럼만 조회
SELECT prod_id, prod_name 
FROM prod;

-- 1) lprod 테이블의 모든 컬럼 조회

-- 2) buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회

-- 3) cart 테이블에서 모든 데이터를 조회

-- 4) member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회


-- 연산자 / 날짜연산
-- date type + 정수 : 일자를 더한다.
-- null을 포함한 연산의 결과는 항상 null이다.
SELECT userid, usernm, reg_dt, 
       reg_dt + 5 reg_dt_after5, 
       reg_dt - 5 as reg_dt_before5 --alias(별칭)가 적용이 돼서 컬럼명이 바뀜.
FROM users;

commit; --트랜잭션을 마무리 짓는 단계

-- 1) prod 테이블에서 prod_id, prod_name 두 컬럼을 조회 (id, name으로 별칭 지정)

-- 2) lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회 (gu, nm으로 별칭 지정)

-- 3) buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회(바이어아이디, 이름으로 별칭 지정)


-- 문자열 결합
-- java + --> sql ||
-- CONCAT(str, str) 함수
-- users테이블의 userid, usernm
SELECT  userid, usernm,
        userid || usernm,
        CONCAT(userid, usernm)     
FROM users;

-- 문자열 상수 (컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' || userid,
        CONCAT('사용자 아이디 : ' , userid)
FROM users;

-- 실습 sel_con1)
-- 현재 접속한 사용자가 소유한 테이블 목록을 조회

-- 문자열 결합을 이용하여 다음과 같이 조회되도록 쿼리 작성


-- desc table : 해당테이블에 대한 간략한 정보를 알려줌.
-- 테이블에 정의된 컬럼을 알고 싶을 때
-- 1. desc 테이블명
-- 2. select * from 테이블명
desc emp; 

SELECT *
FROM emp;

-- WHERE절, 조건 연산자
SELECT *
FROM users
WHERE userid = 'brown';

-- usernm이 샐리인 데이터를 조회하는 쿼리를 작성
