USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_Name					: SP_CUS_POINT_INSERT
■ Description				: 포인트 적립
■ Input Parameter			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

-- 적립
public enum PointAccTypeEnum { 일반적립 = 1, 관리자적립 = 2, 회원가입 = 3, 컨텐츠적립 = 4, 이벤트적립 = 5, 포인트이전 = 6, 추천인 = 7, 피추천인 = 8, VIP추가적립 = 9, 기타 = 99 };
-- 사용
public enum PointUseTypeEnum { 일반사용 = 1, 기간만료 = 2, 관리자차감 = 3, 포인트이전 = 4, 탈퇴소멸 = 5, 사용취소 = 6, OK캐쉬백사용 = 7, 기타 = 9 };

	EXEC SP_CUS_POINT_INSERT @CUS_NO, @ACC_TYPE, @POINT_PRICE, @RES_CODE, @TITLE, @REMARK, @NEW_CODE, @EXPIRED_MONTH 
	
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-05-07		박형만			최초생성
   2013-10-15		박형만			예약출발자에 포인트 번호 ,실적립포인트 업데이트
   2013-11-21		박형만			새로입력된 POINT_NO 리턴
   2020-03-30		김성호			등록포인트 유효시간 설정 가능하게 수정
   2020-11-18		김성호			상품적립(ACC_TYPE=1)인 경우만 RES_CUSTOMER 업데이트
   2020-12-21		홍종우			유효기간(@EXPIRE_MONTH)이 0이면 36개월로 변경 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_POINT_INSERT]
	@CUS_NO						INT,
	@ACC_TYPE					INT,
	@POINT_PRICE				INT,
	@RES_CODE					RES_CODE,
	@TITLE						VARCHAR(100), 
	@REMARK						VARCHAR(200), 
	@NEW_CODE					NEW_CODE,
	@EXPIRE_MONTH				INT = 36	-- DEFAULT 유효기간 36개월
AS

DECLARE @TOTAL_POINT INT

-- 유효기간(@EXPIRE_MONTH)이 0이면 36개월로 변경
IF @EXPIRE_MONTH = 0
BEGIN
	SET @EXPIRE_MONTH = 36
END

SET @TOTAL_POINT = ISNULL(
	(	SELECT TOP 1 TOTAL_PRICE
		FROM CUS_POINT AS CP WITH(NOLOCK)
		WHERE CP.CUS_NO = @CUS_NO ORDER BY POINT_NO DESC ) , 0 ) + @POINT_PRICE 

-- 유효기간 현재 3년 으로 . POINT_TYPE = 1 적립 X
-- 설정된 유효기간으로 등록
INSERT INTO CUS_POINT ( CUS_NO,POINT_TYPE,ACC_USE_TYPE,START_DATE,END_DATE,
	POINT_PRICE,RES_CODE,TITLE,TOTAL_PRICE,REMARK,NEW_CODE,NEW_DATE,MASTER_SEQ,BOARD_SEQ ) 
VALUES ( @CUS_NO,1,@ACC_TYPE,GETDATE(),DATEADD(MM,@EXPIRE_MONTH,GETDATE()),
	@POINT_PRICE,@RES_CODE,@TITLE,@TOTAL_POINT,@REMARK,@NEW_CODE,GETDATE(),NULL,NULL ) 

--예약포인트 번호 업데이트
DECLARE @POINT_NO INT 
SET @POINT_NO = @@IDENTITY 
IF @RES_CODE IS NOT NULL 
	AND EXISTS ( SELECT 1 FROM RES_CUSTOMER_damo WITH(NOLOCK)
		WHERE RES_CODE = @RES_CODE AND CUS_NO = @CUS_NO 
		AND RES_STATE IN (0)
	) AND @ACC_TYPE = 1
BEGIN
	UPDATE RES_CUSTOMER_damo 
	SET POINT_REF = @POINT_NO , POINT_PRICE  = @POINT_PRICE 
	WHERE RES_CODE = @RES_CODE AND CUS_NO = @CUS_NO 
	AND RES_STATE IN (0)
END 

SELECT ISNULL(@POINT_NO,0)

GO
