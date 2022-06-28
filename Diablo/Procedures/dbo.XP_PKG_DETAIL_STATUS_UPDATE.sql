USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_PKG_DETAIL_STATUS_UPDATE
- 기 능 : 포인트 적립
====================================================================================
	참고내용
====================================================================================
- 예제
함수_행사상태정보_수정
 EXEC XP_PKG_DETAIL_STATUS_UPDATE '','Y','DEP_CFM_YN' , '9999999'
====================================================================================
	변경내역
====================================================================================
- 2014-07-25 박형만 신규 작성 
- 2019-11-27 박형만	출발확정시 출발 예정이Y 이면 N 으로   수정하기 , 출발미확정시 출발예정끄기 
===================================================================================*/
CREATE PROC [dbo].[XP_PKG_DETAIL_STATUS_UPDATE]
	@PRO_CODE					PRO_CODE,
	@STATE_YN					CHAR(1),
	@COL_NAME					VARCHAR(100),
	@EMP_CODE					NEW_CODE
AS 

IF @COL_NAME = 'DEP_CFM_YN'
BEGIN
	UPDATE PKG_DETAIL SET DEP_CFM_YN = @STATE_YN
	,CONFIRM_YN = CASE WHEN @STATE_YN IN ( 'Y','F') AND CONFIRM_YN = 'Y' THEN 'N' -- 출발확정이면서 출발예정인 경우 출발예정n으로 
			WHEN @STATE_YN IN ( 'N') THEN 'N' -- -- 출발미확정은 무조건 출발미예정으로 
			 ELSE CONFIRM_YN END 
	,EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'CONFIRM_YN'
BEGIN
	UPDATE PKG_DETAIL 
	SET CONFIRM_YN =  @STATE_YN 
	,DEP_CFM_YN = CASE WHEN @STATE_YN = 'Y' AND DEP_CFM_YN IN ('Y','F') THEN 'N' ELSE DEP_CFM_YN END  -- 출발예정변경이고 기존출발확정이면 출발미확정으로
	,EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'UNITE_YN'
BEGIN
	UPDATE PKG_DETAIL SET UNITE_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'AIR_CFM_YN'
BEGIN
	UPDATE PKG_DETAIL SET AIR_CFM_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'ROOM_CFM_YN'
BEGIN
	UPDATE PKG_DETAIL SET ROOM_CFM_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'SCHEDULE_CFM_YN'
BEGIN
	UPDATE PKG_DETAIL SET SCHEDULE_CFM_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'PRICE_CFM_YN'
BEGIN
	UPDATE PKG_DETAIL SET PRICE_CFM_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 
ELSE IF @COL_NAME = 'RES_ADD_YN'
BEGIN
	UPDATE PKG_DETAIL SET RES_ADD_YN = @STATE_YN, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
	WHERE PRO_CODE = @PRO_CODE
END 



GO
