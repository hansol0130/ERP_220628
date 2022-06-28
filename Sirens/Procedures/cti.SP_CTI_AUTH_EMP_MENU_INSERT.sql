USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_EMP_MENU_INSERT
■ DESCRIPTION				:  사용자 화면권한 복
■ INPUT PARAMETER			:  
	@FROM_EMP_CODE			: 기준 직원코드	
	@TO_EMP_CODE			: 신규 직원코드
	@EMP_CODE				: 등록 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_EMP_MENU_INSERT '2012019', '2012010', '2012019';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_EMP_MENU_INSERT]
--DECLARE
	@FROM_EMP_CODE	VARCHAR(7),
	@TO_EMP_CODE		VARCHAR(7),
	@EMP_CODE	VARCHAR(7)

--SET @FROM_EMP_CODE = '2012019'
--SET @TO_EMP_CODE = '2012019'
--SET @EMP_CODE = '2012019'

AS

BEGIN

 -- 사용자별 화면권한 삭제
  BEGIN
    DELETE FROM sirens.cti.CTI_AUTH 
    WHERE AUTH_ID = @TO_EMP_CODE;
  END
  
  
  -- 사용자 화면권한 복사
  BEGIN
  
    INSERT INTO Sirens.cti.CTI_AUTH (
      AUTH_ID
      ,AUTH_NAME
      ,MENU_ID
      ,MENU_NAME
      ,REMARK
      ,NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE
    ) 
    SELECT 
      @TO_EMP_CODE, 
      (SELECT KOR_NAME FROM Diablo.dbo.EMP_MASTER WHERE EMP_CODE = @TO_EMP_CODE),
      MENU_ID,
      MENU_NAME,
      '사용자단위등록',
      GETDATE(), @EMP_CODE, GETDATE(), @EMP_CODE
    FROM   Sirens.cti.CTI_AUTH
    WHERE AUTH_ID = @FROM_EMP_CODE;
    
    END
    
END
GO
