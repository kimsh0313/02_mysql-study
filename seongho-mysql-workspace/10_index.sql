/*
INDEX
1. 색인객체
2. SQL 명령문의 처리 속도를 향상시키기 위한 객체로 데이터 빠르게 조회 ㄱㄴ한 포인터 제공
3. 주로 WHERE 절 조건이나 JOIN 연산에 사용되는 컬럼을 가지고 생성함
4. 특징
    이진트리구조로 만들어짐
    key-value 형태로 생성됨
    key에는 인덱스로 지정된 컬럼값, value로는 행이 저장된 주소값 저장
5. 장점 
    데이터 검색시 전체 테이블 검색 필요 없음 인덱스를 통해 하기 떄문 속도 빠름
    시스템에 걸리는 부하를 줄여 시스템 전체 성능을 향상
6. 단점
    인덱스 생성을 위한 추가적인 저장공간 필용
    인덱스 생성시 시간이 걸림
    데이터가 변경 (INSERT,UPDATE,DELETE)될때 마다 인덱스도 갱신해야됨
    ㄴ즉 ,변경 작업이 빈번한 테이블에 INDEX생성시 오히려 성능 저하가 발생될 수  있음


%%%인덱스 적용 예ㅖㅖㅖㅖㅖㅖ
1. 어떤 컬럼에 인덱스를 만들면 좋을까아
    중복된 데이터 값들이 없는 고유한 데이터값을 가지는 컬럼에 만드는게 좋음
    선택도(selectivity)가 좋은 컬럼이라함
    ex 아이디/주민/이메일 :구웃~
        이름 : 낫 베도~
        성별/여부 : 베도~
    효율적인 인뎃스 사용 예\
    WHERE절에 자주 사용되는 컬럼
    두 개 이상의 컬럼이 where절이나 JOIN의 조건으로 자주 사용되는 경우
    한 테이블에 저장된 데이터 용량이 클 경우

비효율적인 인덱스 사용 예
    중복값이 많은 컬러엄
    null많은 컬럼
*/

/*
실행계획스

테이블 접근 방법, 조인순서, 데이터 처리 방식 등이 표현되어있음

type종류 (성능 우선순위로 나열
system : 0개 또는 하나의 row 를 가진 테이블
const   : primary key나 unique의 모든 컬럼에 대해 equal 조건으로 검색 반드시 한 건의 레코드만 반화안
ref       : 조인의 순서와 인덱스의 종류와 관계없이 equal 조건으로 검색
unique_subquery : IN 형태의 조건에서 반환 값에 중복 없음
index_subquery : unique_subquery와 비슷한데 반환 값에 중복 있음
range               :  인덱스를 하나의 값이 아니라 범위로 검색
index               : 인덱스를 처음부터 끝까지 읽는 인덱스 풀 스캔
all                   :풀스캔, 성능 가장 떨어짐
*/
EXPLAIN SELECT *FROM tbl_menu; -- 풀스캔
EXPLAIN SELECT *FROM tbl_menu WHERE menu_name = '열무김치라떼'; -- 풀스캔
EXPLAIN SELECT * FROM tbl_menu WHERE menu_code = 1 ;
EXPLAIN SELECT * FROM tbl_menu WHERE category_code = 4 ;

CREATE TABLE phone(
    phone_code INT primary key,
    phone_name VARCHAR(100),
    phone_price DECIMAL(10,2)
);
INSERT INTO phone(phone_code, phone_name, phone_price)
VALUES(1,'갤럭시 s 24' , 1800000)
,(2,'아이폰 16 pro' , 1900000)
,(3,'갤럭시 z' , 1720000);

SELECT * FROM phone;

SHOW INDEX FROM phone;


EXPLAIN
SELECT *
FROM phone
-- WHERE phone_name = '아이폰 16 pro';
-- WHERE phone_price = '3000000';
WHERE phone_code = 1;

-- 인덱스 생성
CREATE INDEX idx_phone_price
ON phone(phone_price);

SHOW INDEX FROM phone;

EXPLAIN SELECT *FROM phone WHERE phone_price =1800000;

-- 인덱스 삭제
DROP INDEX idx_phone_price ON phone;

CREATE INDEX idx_phone_name
ON phone(phone_name);

EXPLAIN
SELECT *
FROM phone
WHERE
  --  phone_name = '아이폰 16 pro';
--    phone_name != '아이폰 16 pro';
--    phone_name LIKE '아이폰%';
  --  phone_name LIKE '%아이폰%';
  -- LEFT(phone_name, 1) ='아';
--  phone_name IS NULL;
--  phone_name IS NOT NULL;
phone_name = 16; 

CREATE INDEX idx_phone_name_price
on phone(phone_name,phone_price);

SHOW INDEX FROM phone;

EXPLAIN
SELECT*
FROM phone
-- WHERE phone_name = '아이폰 16 pro' AND phone_price = 1900000; -- o ref
-- WHERE phone_name = '아이폰 16 pro' AND phone_price = 1900000; -- o ref 바꿔도
-- WHERE phone_name = '아이폰 16 pro' ; -- o ref
WHERE phone_price = 1900000 ; -- o index


