/*
PROCEDURE
데이터베이스에 저장된 서브프로그램으로 여러 SQL문을 포함하고 실행가능하도록 설계되어있음
주로 데이터베이스 작업을 자동화하거나 복잡한 비즈니스 규칙을 구현할 때 사용
저장된 프로시저는 CALL 키워드를 통해서 호출가능. SQL문에서 호출 불가

CREATE PROCEDURE 프로시저명(parameter_list) -- IN(기본값)/OUT/INOUT
BEGIN
    프로시저 본문
END;

CALL 프로시저명();


*/
CREATE TABLE tbl_member(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    pw VARCHAR (16) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$
CREATE PROCEDURE create_user(
    username VARCHAR(50), -- IN 모드변수
    pw VARCHAR(16), -- IN 모드변수
    OUT mem_id INT
    )
BEGIN
    INSERT INTO
        tbl_member(username,pw)
    VALUES
        (username,pw);
    SET mem_id = LAST_INSERT_ID();
END$$
DELIMITER ;

CALL create_user('hong-gildong', '1234' ,@mem_id) ;


DELIMITER $$
CREATE PROCEDURE proc_loop(IN n INT ,OUT sum INT)
BEGIN
    DECLARE i INT DEFAULT 1; -- 증감 변수
    SET sum = 0;
   sum_label: LOOP
        SET SUM = sum + i;
        SET i = i + 1;
        IF i>n THEN LEAVE sum_label;
        END IF;
    END LOOP;
END$$
DELIMITER ;

CALL proc_loop(10, @sum_result);
SELECT @sum_result;

DELIMITER $$
CREATE PROCEDURE proc_while_loop(IN n INT, OUT sum INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    SET sum = 0;
    WHILE i<=n DO
        IF i% 2 =0
            THEN SET sum= sum+i;
        END IF;
        
        SET i= i+1;
    END WHILE;
END$$
DELIMITER ;
CALL proc_while_loop(10,@sum_wloop);
SELECT @sum_wloop;

-- 제곱수가 1000을 넘지 않는 최대 정수 구하기
DELIMITER $$
CREATE PROCEDURE proc_repeat_until(OUT result INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    REPEAT
        SET i = i + 1;
        SET result = i;
    UNTIL i*i >1000 END REPEAT;
    SET result = result - 1;
END $$
DELIMITER ;
DROP PROCEDURE proc_repeat_until;
CALL proc_repeat_until(@result);
SELECT @result;
