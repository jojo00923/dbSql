-- 어제 못푼 문제

-- 2
-- Q. 달력 만들기
SELECT MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, MIN(DECODE(d, 3, dt)) TUE,  
       MIN(DECODE(d, 4, dt)) WED, MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI,  
       MIN(DECODE(d, 7, dt)) SAT  
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'd') d,
            TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) -
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'd') + 1 f_sun
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY f_sun
ORDER BY f_sun;

-- 2-1
-- Q. 복습(실습 calendar2) 20P
-- 해당 월의 모든 주차에 대해 날짜를 다음과 같이 출력하도록 쿼리를 작성해보세요
SELECT MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, MIN(DECODE(d, 3, dt)) TUE,  
       MIN(DECODE(d, 4, dt)) WED, MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI,  
       MIN(DECODE(d, 7, dt)) SAT  
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1), 'd') d,
            TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1) -
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1), 'd') + 1 f_sun
    FROM dual
    CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'D')) + 1 -
    (TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1))
GROUP BY f_sun
ORDER BY f_sun;

-- Q. 계층쿼리 (실습 h_2)
-- 정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요. 73p

-- 과제 h_2
-- 정보시스템부 하위의 조직 계층구조 조회(dept0_02)
SELECT dept_h.*, level lv, deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR는 내가 현재 읽은 데이터를 의미함.  =을 기준으로 위치를 바꿔도 동일함. CONNECT BY deptcd = PRIOR p_deptcd
-----------------------------------------------------------------------------------------

-- 상향식 계층쿼리
-- 특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다)
-- 디자인팀을 시작으로 상위 부서를 조회
-- 디자인팀 dept0_00_0

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

---***********************************************************************상향식 계층쿼리 스샷
-----------------------------------------------------------------------------------------
-- h_sum 테이블 생성
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

-- Q. 계층쿼리 (실습 h_4)  sql응용 ppt 79p
-- 계층형쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가
-- 나오도록 쿼리를 작성하시오.
-- s_id : 노드 아이디
-- ps_id : 부모 노드 아이디
-- value : 노드 값

--h_4 : 하향식 쿼리
select *
from h_sum;
SELECT LPAD(' ',4*(level-1),' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

-----------------------------------------------------------------------------------------

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

-- Q. 계층쿼리 실습 h_5
/*
    계층형쿼리 스크립트.sql을 이용하여 테이블을 생성하고 다음과같은
    결과가 나오도록 쿼리를 작성 하시오.
    org_cd  : 부서코드
    parent_org_cd : 부모 부서코드
    no_emp : 부서 인원수
    */
SELECT *
FROM no_emp;
SELECT level, LPAD(' ',4*(level-1),' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-----------------------------------------------------------------------------------------
-- pruning branch (가지치기)
-- 계층쿼리에서 (WHERE)절은 START WITH, CONNECT BY절이 전부 적용된 이후에 실행된다.

-- dept_h 테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 계층쿼리가 완성된 이후 WHERE절이 적용된다.
-- 정보기획부 삭제되어서 하위팀인 기획팀이 디자인부 아래에 있는것처럼 보인다.
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 정보기획부 밑에 있는 하위 기획부도 같이 삭제
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '정보기획부';
-----------------------------------------------------------------------------------------
-- 83p
-- SYS_CONNECT_BY_PATH(컬럼명, '-') : 해당로그가 어떤 계층 데이터를 타고 왔는지 알 수 있음. (구분자를 왼쪽에 넣어줌)
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       SYS_CONNECT_BY_PATH(org_cd, '-') path_org_cd
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') : ltrim 함수를 하면 왼쪽부터 -가 사라짐
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- 정리
-- CONNECT_BY_ROOT(col) : col의 최상위 노트 컬럼 값
-- SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--      . LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
-- CONNECT_BY_ISLEAF : 해당 row가 leaf node인지 판별 (1: O, 0 : X)

-----------------------------------------------------------------------------------------
-- 86p
-- 게시글 계층형쿼리 샘플 자료
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

-- Q. 계층쿼리 (게시글 계층형쿼리 샘플 자료.sql, 실습 h6) 86p
-- 게시글을 저장하는 board_test 테이블을 이용하여 계층 쿼리를 작성하시오.
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq;

-- Q. 계층쿼리 (게시글 계층형쿼리 샘플 자료.sql, 실습 h7) 87p
-- 게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬하시오.
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;

-- Q. 계층쿼리 (게시글 계층형쿼리 샘플 자료.sql, 실습 h9) 94p
-- 일반적인 게시판을 보면 최상위글은 최신글이 먼저 오고, 답글의 경우 작성한 순서대로 정렬이 된다.
-- 어떻게 하면 최상위글은 최신글 순(desc)으로 정렬하고, 답글을 순차적(asc)으로 정렬할 수 있을까?

-- 내가 시도한 것
SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY DECODE(parent_seq, null, seq desc, seq);

SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY DECODE(parent_seq, null, seq || 'desc', seq);

-- 이슬언니 풀이
SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title,
       CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
       CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END DESC, seq;

--쌤 풀이 1 :  CONNECT_BY_ROOT를 이용해서 1과 1에 대한 답글은 최상위인 1이, ...2가, 4가 들어감.인라인뷰를 이용해 order by 해줌.
SELECT *
FROM
    (SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title,
           CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq IS NULL   
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC, seq;

-- 쌤 풀이 2 : 컬럼 하나를 추가해서 1에 대한 답글은 1, 2에 대한 답글은 2, 4에 대한 답글은 4로 입력한 뒤 orderby해줌)
SELECT *
FROM board_test;
-- 글 그룹번호 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

----------------------------------------------------------------------------------------- 
-- Q. 5000 옆에 3000, 3000 옆에 3000, 3000 옆에 2975... 800 옆에 NULL
SELECT a.ename, a.sal, b.sal
FROM
(SELECT ename, sal, ROWNUM rn
FROM
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC))a
    
    LEFT OUTER JOIN 
    
    (SELECT ename, sal, ROWNUM-1 rn
     FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC))b
ON (a.rn = b.rn);

