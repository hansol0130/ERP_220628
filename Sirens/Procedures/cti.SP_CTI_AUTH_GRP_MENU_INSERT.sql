USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_GRP_MENU_INSERT
■ DESCRIPTION				:  선택그룹 화면권한 저장
■ INPUT PARAMETER			:  
	@AUTH_ID				: 권한ID
	@TO_EMP_CODE			: 직원ID
	@EMP_CODE				: 작원직원ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_GRP_MENU_INSERT '999', '2012010', '1234567';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_GRP_MENU_INSERT]
--DECLARE
	@AUTH_ID	VARCHAR(20),
	@TO_EMP_CODE		VARCHAR(7),
	@EMP_CODE	VARCHAR(7)

--SET @AUTH_ID = '999'
--SET @TO_EMP_CODE = '2012019'
--SET @EMP_CODE = '2012019'

AS

BEGIN

 -- 사용자별 화면권한 삭제
  BEGIN
    DELETE FROM Sirens.cti.CTI_AUTH 
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
      A.MENU_ID,
       (SELECT MENU_NAME FROM Sirens.cti.CTI_MENU WHERE MENU_ID = A.MENU_ID),
      '그룹단위등록',
      GETDATE(), @EMP_CODE, GETDATE(), @EMP_CODE
    FROM   Sirens.cti.CTI_AUTH_MENU A
    WHERE A.AUTH_ID = @AUTH_ID;
    
    END
    
END
GO
