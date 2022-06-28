USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_EMP_INSERT
■ DESCRIPTION				:  사용자별 화면권한 저장
■ INPUT PARAMETER			:  
@AUTH_ID char(3),			: 권한ID
@MENU_ID(4),				: 메뉴ID
@EMP_CODE varchar(7)		: 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec  SP_CTI_AUTH_EMP_INSERT'2012019', 'A001', '2012019'; 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_EMP_INSERT]
@AUTH_ID varchar(20), @MENU_ID varchar(20), @EMP_CODE varchar(7)
WITH EXEC AS CALLER
AS
BEGIN

  MERGE sirens.cti.CTI_AUTH AS TARGET
    USING (SELECT @AUTH_ID AS AUTH_ID, @MENU_ID AS MENU_ID) AS SOURCE
    ON (TARGET.AUTH_ID = SOURCE.AUTH_ID AND TARGET.MENU_ID = SOURCE.MENU_ID)
  WHEN MATCHED THEN
    UPDATE SET 
      TARGET.EDT_DATE = GETDATE(), 
      TARGET.EDT_CODE = @EMP_CODE
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (AUTH_ID, AUTH_NAME, MENU_ID, MENU_NAME, REMARK, NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE)
    VALUES (
      @AUTH_ID, 
      (SELECT KOR_NAME FROM Diablo.dbo.EMP_MASTER WHERE EMP_CODE = @AUTH_ID),
      @MENU_ID,
      (SELECT MENU_NAME FROM Sirens.cti.CTI_MENU WHERE MENU_ID = @MENU_ID),
      '화면단위등록',
      GETDATE(), @EMP_CODE, GETDATE(), @EMP_CODE
  );
    
END
GO
