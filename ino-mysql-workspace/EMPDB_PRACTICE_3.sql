/* ## SELECT(GROUP BY, HAVING) 실습문제 - empdb ## */
use empdb;

-- 1. EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.
SELECT * FROM employee;

SELECT
    JOB_CODE
  , COUNT(*)
  , AVG(SALARY)
FROM
    employee
GROUP BY
    JOB_CODE
HAVING
    JOB_CODE != 'J1';
 /*
    --------------- 출력 예시 -------------
    직급코드    직급별 사원수      평균급여
    ----------------------------------------
        J2           3              4726666
        J3           3              3600000
        J4           4              2330000
        J5           3              2820000
        J6           6              2624373
        J7           4              2017500
*/



-- 2. EMPLOYEE테이블에서 직급이 J1을 제외하고, 입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.
--   (select에는 groupby절에 명시한 컬럼만 작성가능)
SELECT
    LEFT(HIRE_DATE,4) AS 입사년
  , COUNT(*)
FROM
    employee
WHERE JOB_CODE != 'J1'
GROUP BY
    LEFT(HIRE_DATE,4)
ORDER BY
    입사년;
    
/*
    ---- 출력 예시 -------
    입사년     인원수
    ----------------------
    1994       3
    1996       1
    1997       1
    1999       3
    2000       1
    2001       3
    ...
    총 출력row는 17
*/


SELECT * FROM employee;
-- 3. 성별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오.
SELECT
    CASE SUBSTRING(EMP_NO, 8, 1)
        WHEN 1 THEN '남'
        WHEN 2 THEN '여'
        WHEN 3 THEN '남'
        WHEN 4 THEN '여'
    END AS 성별
  , FLOOR(AVG(SALARY)) AS 평균
  , SUM(SALARY) AS 합계
  , COUNT(*) AS 인원수
FROM
    employee
GROUP BY 
    성별
ORDER BY 
    인원수 DESC;
/*
    ------------------- 출력 예시 -------------------
    셩별     평균          합계           인원수
    -------------------------------------------------
    남       3,317,333     49,760,000       15
    여       2,757,360     24,816,240       9
*/



-- 4. 직급별 인원수가 3명이상인 직급과 총원을 조회

SELECT
    JOB_CODE AS 직급
  , COUNT(*) AS 인원수
FROM 
    employee
GROUP BY
    직급
HAVING
    인원수 >= 3;
/*
    ------------ 출력 예시 ---------------
    직급          인원수
    -------------------------------------
    J2              3
    J3              3
    J4              4
    J5              3
    J6              6
    J7              4
*/