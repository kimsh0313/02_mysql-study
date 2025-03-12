use chundb;

-- 1. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 
--    누구인가? (국문학과의 '학과코드'는 학과 테이블(tb_department)을 조회해서 찾아 내도록 하자)
SELECT student_name
FROM tb_student 
JOIN tb_department 
ON tb_department.department_name='국어국문학과' 
WHERE ABSENCE_YN = 'Y'
AND (substring(STUDENT_SSN, 8, 1) = 2 OR substring(STUDENT_SSN, 8, 1) = 4)
AND tb_student.department_no = tb_department.department_no;

-- 2. 영어영문학과(학과코드 '002') 학생들의 학번과 이름, 입학년도를 입학년도가 빠른순으로 표시하는 SQL 문장을 작성하시오.
--    (단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT STUDENT_NO AS '학번', student_name AS '이름', DATE_FORMAT(ENTRANCE_DATE, '%Y-%m-%d') AS '입학년도'
FROM tb_student s
JOIN tb_department d
ON d.department_name='영어영문학과' AND s.department_no = d.department_no
ORDER BY ENTRANCE_DATE;

-- 3. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
--    그 교수의 이름과 주민번호를 화면에 출력하는 sql 문장을 작성해 보자.
SELECT professor_name, professor_ssn
FROM tb_professor
WHERE CHAR_LENGTH(professor_name) <> 3;

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 sql 문장을 작성하시오. 
--    단, 출력 헤더는’이름’ 이 찍히도록 한다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
SELECT substring(professor_name, 2) AS '이름'
FROM tb_professor;

-- 5. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 sql 문을 작성하시오.
--    단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
SELECT ROUND(AVG(POINT), 1) AS '평점' 
FROM tb_grade WHERE
STUDENT_NO="A517178";


-- 6. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 sql 문을 작성하시오.
SELECT COUNT(*) FROM tb_student 
WHERE COACH_PROFESSOR_NO IS NULL;


-- 7. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
SELECT department_no AS '학과번호', COUNT(*) AS '학생수(명)'
FROM tb_student
GROUP BY department_no
ORDER BY department_no;


-- 8. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 sql 문장을 작성하시오.
SELECT department_no AS '학과코드명', COUNT(*) AS '휴학생 수'
FROM tb_student
WHERE ABSENCE_YN = "Y"
GROUP BY 학과코드명
ORDER BY 학과코드명;


-- 9. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤 sql 문장을 사용하면 가능하겠는가?
SELECT student_name AS '동일이름', COUNT(*) AS '동명인 수'
FROM tb_student
GROUP BY student_name
HAVING COUNT(*) > 1
ORDER BY student_name;

-- 10. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 sql 문을 작성하시오. 
--    단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
SELECT SUBSTRING(term_no, 1, 4) AS '년도' , ROUND(AVG(POINT), 1) AS '년도 별 평점'
FROM tb_grade
WHERE student_no = 'A112113'
GROUP BY SUBSTRING(term_no, 1, 4);

-- 11. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총평점을 구하는 sql 문을 작성하시오.
--     (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.) - Hint. ROLLUP

SELECT 
SUBSTRING(term_no, 1, 4) AS '년도'
, SUBSTRING(term_no, 5, 2) AS '학기'
, ROUND(AVG(POINT), 1) AS '년도 별 평점'
FROM tb_grade
WHERE student_no = 'A112113'
GROUP BY substring(term_no, 1, 4), substring(term_no, 5, 2)
WITH ROLLUP;
