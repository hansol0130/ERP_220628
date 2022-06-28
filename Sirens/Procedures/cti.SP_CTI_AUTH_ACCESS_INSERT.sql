USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_ACCESS_INSERT
■ DESCRIPTION				:  사용자별 전체권한 저장
■ INPUT PARAMETER			:   
@EMP_CODE varchar(7) : 직원코드
@ACCESS_YN int		 : 전체권한 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_ACCESS_INSERT '2012011', 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_ACCESS_INSERT]
--DECLARE
  @EMP_CODE	VARCHAR(20),
  @ACCESS_YN	CHAR(1)
  
--SET @EMP_CODE = '2012011'
--SET @ACCESS_YN = 1

AS
BEGIN

  MERGE Sirens.cti.CTI_AUTH_ACCESS AS TARGET
    USING (SELECT @EMP_CODE AS EMP_CODE) AS SOURCE
    ON (TARGET.EMP_CODE = SOURCE.EMP_CODE)
  WHEN MATCHED THEN
    UPDATE SET 
      TARGET.ACCESS_YN = @ACCESS_YN
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (
      EMP_CODE, 
      ACCESS_YN
    )
    VALUES (
      @EMP_CODE,
      @ACCESS_YN 
  );
    
END
GO
