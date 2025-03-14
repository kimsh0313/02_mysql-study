/* ## SELECT(함수) 실습문제 - chundb ## */
use chundb;

-- 1. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 
--    누구인가? (국문학과의 '학과코드'는 학과 테이블(tb_department)을 조회해서 찾아 내도록 하자)
/*
    student_name
    --------------
    한수현
    --------------
    
    1개의 행 조회
*/
select * from tb_student;
select * from tb_department;
select student_name
from tb_student join tb_department 
on tb_department.department_name='국어국문학과' and tb_student.department_no = tb_department.department_no
where ABSENCE_YN = 'Y' and (substring(STUDENT_SSN, 8, 1) = 2 or substring(STUDENT_SSN, 8, 1) = 4);


-- 2. 영어영문학과(학과코드 '002') 학생들의 학번과 이름, 입학년도를 입학년도가 빠른순으로 표시하는 SQL 문장을 작성하시오.
--    (단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
/*
    학번      | 이름    | 입학년도
    ------------------------------------
    A9973003  | 김용근	| 2016-03-01
    A473015	  | 배용원	| 2021-03-01
    A517105	  | 이신열	| 2022-03-01
    ------------------------------------
    
    3개의 행 조회
*/
select * from tb_student;
select * from tb_department;
select STUDENT_NO as "학번", student_name as "이름", DATE_FORMAT(ENTRANCE_DATE, '%Y-%m-%d') as "입학년도"
from tb_student s join tb_department d
on d.department_name='영어영문학과' and s.department_no = d.department_no
order by ENTRANCE_DATE;


-- 3. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
--    그 교수의 이름과 주민번호를 화면에 출력하는 sql 문장을 작성해 보자.
/*
    professor_name  | professor_ssn
    ---------------------------------
    강혁	        | 601004-1100528
    박강아름	    | 681201-2134896
    ---------------------------------
    
    2개의 행 조회
*/
select * from tb_professor;
select * from tb_department;
select professor_name, professor_ssn
from tb_professor
where CHAR_LENGTH(professor_name) <> 3;

    
-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 sql 문장을 작성하시오. 
--    단, 출력 헤더는’이름’ 이 찍히도록 한다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
/*
    이름
    ------
    진영
    윤필
    원하
    옥현
    경숙
    영주
    수현
    ...
    민정
    해원
    혁호
    ------
    
    114개의 행 조회
*/
select * from tb_professor;
select substring(professor_name, 2) as "이름"
from tb_professor;


-- 5. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 sql 문을 작성하시오.
--    단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
/*
    평점
    -----
    3.6
    -----
*/
select * from tb_student;
select * from tb_grade;
select round(AVG(POINT), 1) as "평점" from tb_grade where STUDENT_NO="A517178";

    
-- 6. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 sql 문을 작성하시오.
/*
    COUNT(*)
    ---------
    9
    ---------
*/
select * from tb_student;
select count(*) from tb_student where COACH_PROFESSOR_NO is null;

    
-- 7. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
/*
    학과번호 | 학생수(명)
    ----------------------
    001	     | 14
    002	     | 3
    003	     | 8
    004	     | 12
    005	     | 10
    006	     | 5
    007	     | 8
        ...
    060	     | 16
    061	     | 7
    062	     | 8
    -----------------------
    62개의 행 조회
*/
select * from tb_student;
select department_no as "학과번호", count(*) as "학생수(명)"
from tb_student
group by department_no
order by department_no;

    
-- 8. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 sql 문장을 작성하시오.
/*
    학과코드명 | 휴학생 수
    ------------------------
    001	       | 2
    002	       | 0
    003	       | 1
    004	       | 1
    005	       | 0
    006	       | 3
    007	       | 1
    008	       | 2
    009	       | 2
        ...
    060	       | 1
    061	       | 2
    062	       | 2    
    ------------------------
    
    62개의 행 조회
*/
select * from tb_student;
select department_no as "학과코드명", count(*) as "휴학생 수"
from tb_student
where ABSENCE_YN = "Y"
group by department_no
order by department_no;

    
-- 9. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤 sql 문장을 사용하면 가능하겠는가?
/*
    동일이름 | 동명인 수
    --------------------
    김경민	 | 2
    김명철	 | 2
    김명훈	 | 2
    김보람	 | 3
    김윤정	 | 2
        ...
    이현성	 | 2
    조기현	 | 2
    최효정	 | 2
    --------------------
    
    20개의 행 조회
*/
select * from tb_student;
select student_name as"동일이름", count(*) as "동명인 수"
from tb_student
group by student_name
having count(*) > 1
order by student_name;


-- 10. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 sql 문을 작성하시오. 
--    단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
/*
    년도  | 년도 별 평점
    --------------------
    2018  |	2.8
    2019  |	2.3
    2020  |	4.0
    2021  |	3.5
    --------------------
*/
select * from tb_student;
select * from tb_grade;
select substring(term_no, 1, 4) as "년도", round(AVG(POINT), 1) as "년도 별 평점"
from tb_grade
where student_no = 'A112113'
group by SUBSTRING(term_no, 1, 4);
    
-- 11. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총평점을 구하는 sql 문을 작성하시오.
--     (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.) - Hint. ROLLUP
/*
    년도  | 학기 | 평점
    --------------------
    2018  | 01   | 2.5
    2018  | 02   | 3.0
    2018  |      | 2.8
    2019  | 01   | 2.0
    2019  | 02   | 2.5
    2019  |      | 2.3
    2020  | 01   | 3.5
    2020  | 02   | 4.5
    2020  | 03   | 4.0
    2020  |      | 4.0
    2021  | 01   | 4.0
    2021  | 02   | 3.0
    2021  |      | 3.5
          |      | 3.2  
    --------------------

    14개의 행 조회
*/
select * from tb_grade where student_no = 'A112113';
select substring(term_no, 1, 4) as "년도", substring(term_no, 5, 2) as "학기", round(AVG(POINT), 1) as "년도 별 평점"
from tb_grade
where student_no = 'A112113'
group by substring(term_no, 1, 4), substring(term_no, 5, 2)
with rollup;