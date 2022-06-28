USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_HTL_MASTER_MAPPING_SEPARATION
- 기 능 : 호텔 마스터 분리 (새호텔로입력)
====================================================================================
	참고내용
====================================================================================
SP_HTL_MASTER_MAPPING_SEPARATION @CITY_CODE,@HOTEL_CODE,@SUP_CODE
SP_HTL_MASTER_MAPPING_SEPARATION '','',''
====================================================================================
	변경내역
====================================================================================
- 2011-10-27 박형만 신규 작성
- 2012-10-29 박형만 임시호텔 테이블 컬럼명 변경 
===================================================================================*/
CREATE PROC [dbo].[SP_HTL_MASTER_MAPPING_SEPARATION]
	@SUP_CODE VARCHAR(10),
	@CITY_CODE VARCHAR(255),
	@HOTEL_CODE VARCHAR(255)
AS 
SET NOCOUNT ON 


	DECLARE @MASTER_CODE VARCHAR(20) 
	DECLARE @BASE_CODE VARCHAR(20)
	DECLARE @CNT_CODE INT

	DECLARE @STATE_INFO VARCHAR(4000)
	
	SET @MASTER_CODE = NULL;
	SET @BASE_CODE = NULL
	SET @STATE_INFO = ''
	SET @STATE_INFO = @SUP_CODE + ' 호텔: ' + @CITY_CODE + '/' +  @HOTEL_CODE  + CHAR(13)
	
	--GTA매핑쿼리
	IF ( @SUP_CODE = 'GTA' ) 
	BEGIN
		
		-- 베이스마스터코드를구한다. (지역+ 'H' + 'H')
		-- 참좋은도시코드와매칭이안되는도시들은일단버린다.
		SELECT @BASE_CODE = D.SIGN + 'HH' FROM TMP_GTA_HOTEL_DETAIL_EN A
		INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'GTA' 
		INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
		INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
		INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
		WHERE A.CITY_CODE = @CITY_CODE AND A.HOTEL_CODE = @HOTEL_CODE
		
		SET @STATE_INFO = @STATE_INFO + '기본코드: ' + ISNULL(@BASE_CODE, '')  + CHAR(13)

		IF ISNULL(@BASE_CODE, '') <> ''
		BEGIN
			-- 호텔입력을위한새로운마스터코드를할당받는다.
			SELECT @BASE_CODE = dbo.FN_GET_HOTEL_MASTER_CODE(@BASE_CODE)
			
			SET @STATE_INFO = @STATE_INFO + '**신규등록: ' + ISNULL(@BASE_CODE, '') + CHAR(13)
			
			-- 신규호텔을입력한다.
			INSERT INTO HTL_MASTER(MASTER_CODE, MASTER_NAME, REGION_CODE, NATION_CODE, STATE_CODE, CITY_CODE, NEW_CODE, HTL_GRADE)
			SELECT @BASE_CODE, A.HOTEL_NAME, D.REGION_CODE, C.NATION_CODE, B.STATE_CODE, B.CITY_CODE, '9999999', A.GRADE FROM TMP_GTA_HOTEL_DETAIL_KO A
			INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'GTA' 
			INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
			INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
			INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
			WHERE A.CITY_CODE = @CITY_CODE AND A.HOTEL_CODE = @HOTEL_CODE	
			
			SET @STATE_INFO = @STATE_INFO + '신규호텔입력완료'	 + CHAR(13)
			
			-- 호텔컨텐츠를입력한다.
			INSERT INTO INF_MASTER(CNT_TYPE, KOR_TITLE, ENG_TITLE, REGION_CODE, NATION_CODE, STATE_CODE, CITY_CODE, GPS_X, GPS_Y, 
			SHORT_DESCRIPTION, DESCRIPTION, NEW_CODE, COPYRIGHT_REMARK, NEW_DATE)
			SELECT 2 AS CNT_TYPE, HOTEL_NAME, 
			(SELECT HOTEL_NAME FROM TMP_GTA_HOTEL_DETAIL_EN E WHERE A.CITY_CODE = E.CITY_CODE AND E.HOTEL_CODE = A.HOTEL_CODE), 
			D.REGION_CODE, C.NATION_CODE, B.STATE_CODE, B.CITY_CODE, A.GPS_X, A.GPS_Y, 
			A.SHORT_LOCATION, HTL_INFO, '9999999' AS NEW_CODE, 'GTA', GETDATE() FROM TMP_GTA_HOTEL_DETAIL_KO A
			INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'GTA' 
			INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
			INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
			INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
			WHERE A.CITY_CODE = @CITY_CODE AND A.HOTEL_CODE = @HOTEL_CODE		
			
			-- 새로추가된컨텐츠고유키번호를가져온다.
			SELECT @CNT_CODE = @@IDENTITY
			
			SET @STATE_INFO = @STATE_INFO + '호텔컨텐츠입력완료 CNT_CODE:' + CONVERT(VARCHAR,@CNT_CODE) + CHAR(13)
			
			-- 호텔컨텐츠확장정보를입력한다.
			INSERT INTO INF_HOTEL(CNT_CODE, STAY_CODE, TEL_NUMBER, FAX_NUMBER, HOMEPAGE, ADDRESS, 
			GRADE, CHECK_IN_TIME, DETAIL_LOCATION, FLR_COUNT, ROOM_COUNT)
			SELECT @CNT_CODE, 'B' AS STAY_CODE, TEL_NUMBER, FAX_NUMBER, HOTEL_URL, 
				   ADDRESS1 + ' ' + ADDRESS2 + ' ' + ADDRESS3 + ' ' + ADDRESS4 AS ADDRESS,
				   A.GRADE, A.CHECK_IN_TIME, A.DETAIL_LOCATION, A.FLR_COUNT, A.ROOM_COUNT 
			FROM TMP_GTA_HOTEL_DETAIL_KO A
			WHERE A.CITY_CODE = @CITY_CODE AND A.HOTEL_CODE = @HOTEL_CODE		
			
			SET @STATE_INFO = @STATE_INFO + '호텔컨텐츠 확장정보입력완료'+ CHAR(13)
			
			-- 컨텐츠의분류를입력한다.
			-- 분류: 숙박
			INSERT INTO INF_TYPE(CNT_CODE, CNT_ATT_CODE)
			VALUES(@CNT_CODE, 89)
			
			-- 분류: 호텔
			INSERT INTO INF_TYPE(CNT_CODE, CNT_ATT_CODE)
			VALUES(@CNT_CODE, 90)
			
			SET @STATE_INFO = @STATE_INFO + '컨텐츠 분류 입력 완료'+ CHAR(13)
			
			-- 호텔정보에컨텐츠코드를업데이트한다. 
			UPDATE HTL_MASTER 
			SET CNT_CODE = @CNT_CODE
			WHERE MASTER_CODE = @BASE_CODE
			
			SET @STATE_INFO = @STATE_INFO + '호텔정보에 컨텐츠코드를 업데이트'+ CHAR(13)

			-- HTL_CONNECT에새로생성된마스터코드를업데이트해준다
			UPDATE HTL_CONNECT			
			SET MASTER_CODE = @BASE_CODE, SHOW_YN = 'Y'
			WHERE SUP_CODE = 'GTA' AND CONNECT_CODE = @HOTEL_CODE AND PROVIDER_CITY_CODE = @CITY_CODE
			
			SET @STATE_INFO = @STATE_INFO + 'HTL_CONNECT에 새로생성된 마스터코드 업데이트'+ CHAR(13)
		END
		ELSE 
		BEGIN
			SET @STATE_INFO = @STATE_INFO +  '정보없음'+ CHAR(13)
		END 
	END
	--RTS매핑쿼리 
	ELSE IF ( @SUP_CODE = 'RTS' ) 
	BEGIN
		-- 베이스마스터코드를구한다. (지역+ 'H' + 'H')
		-- 참좋은도시코드와매칭이안되는도시들은일단버린다.
		SELECT @BASE_CODE = D.SIGN + 'HH' FROM TMP_RTS_HOTEL_LIST A
		INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'RTS' 
		INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
		INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
		INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
		WHERE A.도시코드= @CITY_CODE AND A.호텔코드= @HOTEL_CODE
		
		SET @STATE_INFO = @STATE_INFO + '기본코드: ' + ISNULL(@BASE_CODE, '')  + CHAR(13)
		
		IF ISNULL(@BASE_CODE, '') <> ''
		BEGIN
			-- 호텔입력을위한새로운마스터코드를할당받는다.
			SELECT @BASE_CODE = dbo.FN_GET_HOTEL_MASTER_CODE(@BASE_CODE)
			
			SET @STATE_INFO = @STATE_INFO + '**신규등록: ' + ISNULL(@BASE_CODE, '')  + CHAR(13)
		
			-- 신규호텔을입력한다.
			INSERT INTO HTL_MASTER(MASTER_CODE, MASTER_NAME, REGION_CODE, NATION_CODE, CITY_CODE, NEW_CODE, HTL_GRADE)
			SELECT @BASE_CODE, A.호텔명, D.REGION_CODE, C.NATION_CODE, B.CITY_CODE, '9999999', A.등급 FROM TMP_RTS_HOTEL_LIST A
			INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'RTS' 
			INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
			INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
			INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
			WHERE A.도시코드= @CITY_CODE AND A.호텔코드= @HOTEL_CODE		
			
			SET @STATE_INFO = @STATE_INFO + '신규호텔입력완료'+ CHAR(13)
			
			-- 호텔컨텐츠를입력한다.
			INSERT INTO INF_MASTER(CNT_TYPE, KOR_TITLE, ENG_TITLE, REGION_CODE, NATION_CODE, STATE_CODE, CITY_CODE, GPS_X, GPS_Y, 
			SHORT_DESCRIPTION, DESCRIPTION, NEW_CODE, COPYRIGHT_REMARK, NEW_DATE)
			SELECT 2 AS CNT_TYPE, 호텔명, 호텔명, D.REGION_CODE, C.NATION_CODE, B.STATE_CODE, B.CITY_CODE, A.[X좌표], A.[Y좌표], 
			NULL, 호텔설명, '9999999' AS NEW_CODE, 'RTS', GETDATE() FROM TMP_RTS_HOTEL_LIST A
			INNER JOIN HTL_CITY_CONNECT Z ON Z.PROVIDER_CITY_CODE = @CITY_CODE AND Z.SUP_CODE = 'RTS' 
			INNER JOIN PUB_CITY B ON Z.CITY_CODE = B.CITY_CODE
			INNER JOIN PUB_NATION C ON C.NATION_CODE = B.NATION_CODE
			INNER JOIN PUB_REGION D ON D.REGION_CODE = C.REGION_CODE
			WHERE A.도시코드= @CITY_CODE AND A.호텔코드= @HOTEL_CODE
			
			-- 새로추가된컨텐츠고유키번호를가져온다.
			SET @CNT_CODE = @@IDENTITY
			
			SET @STATE_INFO = @STATE_INFO + '호텔컨텐츠입력완료 CNT_CODE:' + CONVERT(VARCHAR,@CNT_CODE)+ CHAR(13)
			
			-- 호텔컨텐츠확장정보를입력한다.
			INSERT INTO INF_HOTEL(CNT_CODE, STAY_CODE, TEL_NUMBER, FAX_NUMBER, HOMEPAGE, ADDRESS,
			GRADE, CHECK_IN_TIME, DETAIL_LOCATION, FLR_COUNT, ROOM_COUNT)
			SELECT @CNT_CODE, 'B' AS STAY_CODE, 전화번호, 팩스번호, [홈페이지URL], 주소,
				   ISNULL(A.등급, 0), A.[체크인 시간], A.찾아가는방법, ISNULL(A.층수, 0), ISNULL(A.룸수, 0)
			FROM TMP_RTS_HOTEL_LIST A
			WHERE A.도시코드= @CITY_CODE AND A.호텔코드= @HOTEL_CODE		
			
			SET @STATE_INFO = @STATE_INFO + '호텔컨텐츠 확장정보입력완료'+ CHAR(13)
			
			-- 컨텐츠의분류를입력한다.
			-- 분류: 숙박
			INSERT INTO INF_TYPE(CNT_CODE, CNT_ATT_CODE)
			VALUES(@CNT_CODE, 89)
			
			-- 분류: 호텔
			INSERT INTO INF_TYPE(CNT_CODE, CNT_ATT_CODE)
			VALUES(@CNT_CODE, 90)
			
			SET @STATE_INFO = @STATE_INFO + '컨텐츠 분류 입력 완료'+ CHAR(13)
			
			-- 호텔정보에컨텐츠코드를업데이트한다. 
			UPDATE HTL_MASTER 
			SET CNT_CODE = @CNT_CODE
			WHERE MASTER_CODE = @BASE_CODE
			
			SET @STATE_INFO = @STATE_INFO + '호텔정보에 컨텐츠코드를 업데이트'+ CHAR(13)
			
			-- HTL_CONNECT에새로생성된마스터코드를업데이트해준다
			UPDATE HTL_CONNECT			
			SET MASTER_CODE = @BASE_CODE, SHOW_YN = 'Y'
			WHERE SUP_CODE = 'RTS' AND CONNECT_CODE = @HOTEL_CODE AND PROVIDER_CITY_CODE = @CITY_CODE
			
			SET @STATE_INFO = @STATE_INFO + 'HTL_CONNECT에 새로생성된 마스터코드 업데이트'+ CHAR(13)
		END
		ELSE 
		BEGIN
			SET @STATE_INFO = @STATE_INFO +  '정보없음'+ CHAR(13)
		END 
		
	END 
	
	SELECT @STATE_INFO
GO
