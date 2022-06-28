USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_MENU_INSERT
■ DESCRIPTION				:  권한그룹별 메뉴권한 등록
■ INPUT PARAMETER			:  
@AUTH_ID char(3),			: 권한ID
@MENU_ID(4),				: 메뉴ID
@EMP_CODE varchar(7)		: 작업자ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_MENU_INSERT '999', 'A001', '2012019';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_MENU_INSERT]
@AUTH_ID varchar(20), @MENU_ID varchar(20), @EMP_CODE varchar(7)
WITH EXEC AS CALLER
AS
BEGIN

  MERGE sirens.cti.CTI_AUTH_MENU AS TARGET
    USING (SELECT @AUTH_ID AS AUTH_ID, @MENU_ID AS MENU_ID) AS SOURCE
    ON (TARGET.AUTH_ID = SOURCE.AUTH_ID AND TARGET.MENU_ID = SOURCE.MENU_ID)
  WHEN MATCHED THEN
    UPDATE SET TARGET.EDT_DATE = GETDATE(), TARGET.EDT_CODE = @EMP_CODE
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (AUTH_ID, MENU_ID, NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE)
    VALUES (@AUTH_ID, @MENU_ID, GETDATE(), @EMP_CODE, GETDATE(), @EMP_CODE);
END
GO
