USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME									: [ZP_EMP_HOLIDAYYEAR_SELECT_LIST]
■ DESCRIPTION								: 임직원연차데이터 조회
■ INPUT PARAMETER							: 
	@EMP_NAME 								: 직원이름
	@APPRY_YEAR/@TEAM_CODE/@EMP_CODE		: 연자/TEAM코드/직원코드
	@DUTY_TYPE/@POS_TYPE/@WORK_TYPE			: 직책/직급/재직상태
■ OUTPUT PARAMETER							: 
■ EXEC										: 

EXEC ZP_EMP_HOLIDAYYEAR_SELECT_LIST 'L',15, 0, '','','','','','',''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-03-17		김영민		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_EMP_HOLIDAYYEAR_SELECT_LIST]
(
	@FLAG			CHAR(1),
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,
	@EMP_NAME		VARCHAR(20) = '',
	@APPLY_YEAR		VARCHAR(4) = '',
	@TEAM_CODE		VARCHAR(10) = '',
	@EMP_CODE		VARCHAR(10) = '',
	@DUTY_TYPE		INT,--직책
	@POS_TYPE		INT, --직급
	@WORK_TYPE		INT --재직상태
)
AS

BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET ANSI_WARNINGS OFF;
	SET ARITHIGNORE ON;
	SET ARITHABORT OFF;

	DECLARE  @FROM INT, @TO INT;

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	BEGIN
		IF @FLAG = 'C'	
			BEGIN
		SELECT COUNT(*)  FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY TEAM_CODE DESC) AS [ROWNUMBER], 
				EMP_CODE, 
				KOR_NAME, 
				TEAM_CODE, 
				TEAM_NAME, 
				DUTY_TYPE, 
				WORK_TYPE,
				POS_TYPE, 
				APPLY_YEAR,
				POS_NAME, 
				DUTY_NAME, 
				USE_DAY,
				CAN_DAY, 
				(CAN_DAY -  USE_DAY) AS HOLIDAY_USE_DAY,
				USE_PERCENT 
			FROM   (SELECT 
 						A.KOR_NAME, 
						A.EMP_CODE, 
						A.DUTY_TYPE, 
						A.WORK_TYPE,
						A.POS_TYPE, 
						F.APPLY_YEAR,
						A.TEAM_CODE, 
						(SELECT TEAM_NAME 
						FROM   EMP_TEAM WITH(NOLOCK) 
						WHERE  TEAM_CODE = A.TEAM_CODE)               AS TEAM_NAME, 
						(SELECT COD_PUBLIC.PUB_VALUE 
						FROM   COD_PUBLIC 
						WHERE  PUB_TYPE = 'EMP.POSTYPE' 
								AND COD_PUBLIC.PUB_CODE = A.POS_TYPE)  AS POS_NAME, 
						(SELECT COD_PUBLIC.PUB_VALUE 
						FROM   COD_PUBLIC 
						WHERE  COD_PUBLIC.PUB_TYPE = 'EMP.DUTYTYPE' 
								AND COD_PUBLIC.PUB_CODE = A.DUTY_TYPE) AS DUTY_NAME, 
						ISNULL(C.USE_DAY,0) AS USE_DAY, 
						ISNULL(F.CAN_DAY, 0)                           AS CAN_DAY, 
						ISNULL(CAST(CAST(ISNULL(C.USE_DAY, '1') AS FLOAT) / CAST( 
											ISNULL(F.CAN_DAY, '0') AS FLOAT) * 
												100 AS DECIMAL), 0)    AS USE_PERCENT 
				FROM   EMP_MASTER A 
						LEFT JOIN (SELECT EMP_CODE, 
											SUM(HOLIDAY_USE_DAY)AS USE_DAY 
									FROM   EMP_HOLIDAY_HISTORY 
									WHERE  APPLY_YEAR = @APPLY_YEAR 
											AND HOLIDAY_TYPE = '1' AND APPLY_YN='Y'
									GROUP  BY EMP_CODE) AS C 
								ON A.EMP_CODE = C.EMP_CODE 
						LEFT JOIN (SELECT CAN_DAY, APPLY_YEAR, 
											EMP_CODE 
									FROM   EMP_HOLIDAY 
									WHERE  APPLY_YEAR = @APPLY_YEAR 
											AND HOLIDAY_TYPE = '1') AS F 
								ON A.EMP_CODE = F.EMP_CODE 
				WHERE  1 = 1 
						)G 
			WHERE  1 = 1 
			AND (CASE 
			WHEN ISNULL(@TEAM_CODE,'') = ''  THEN 1
			WHEN ISNULL(@TEAM_CODE,'')<> '' AND G.TEAM_CODE  = @TEAM_CODE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@POS_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@POS_TYPE,'')<> '' AND G.POS_TYPE  = @POS_TYPE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@DUTY_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@DUTY_TYPE,'')<> '' AND G.DUTY_TYPE  = @DUTY_TYPE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@EMP_NAME,'') = ''  THEN 1
			WHEN ISNULL(@EMP_NAME,'')<> '' AND G.KOR_NAME  = @EMP_NAME THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@EMP_CODE,'') = ''  THEN 1
			WHEN ISNULL(@EMP_CODE,'')<> '' AND G.EMP_CODE  = @EMP_CODE THEN 1 
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@WORK_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@WORK_TYPE,'')<> '' AND G.WORK_TYPE  = @WORK_TYPE THEN 1 
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@APPLY_YEAR,'') = ''  THEN 1
			WHEN ISNULL(@APPLY_YEAR,'')<> '' AND G.APPLY_YEAR  = @APPLY_YEAR THEN 1 
			ELSE 0
			END) = 1	
		) H
			END
			
		ELSE IF @FLAG = 'L' 
		BEGIN
		SELECT *  FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY TEAM_CODE DESC) AS [ROWNUMBER], 
				EMP_CODE, 
				KOR_NAME, 
				TEAM_CODE, 
				TEAM_NAME, 
				DUTY_TYPE, 
				POS_TYPE,
				WORK_TYPE,
				APPLY_YEAR, 
				POS_NAME, 
				DUTY_NAME, 
				USE_DAY,
				CAN_DAY, 
				(CAN_DAY -  USE_DAY) AS HOLIDAY_USE_DAY,
				USE_PERCENT 
			FROM   (SELECT 
 						A.KOR_NAME, 
						A.EMP_CODE, 
						A.DUTY_TYPE, 
						A.POS_TYPE, 
						A.TEAM_CODE,
						A.WORK_TYPE,
						F.APPLY_YEAR,
						(SELECT TEAM_NAME 
						FROM   EMP_TEAM WITH(NOLOCK) 
						WHERE  TEAM_CODE = A.TEAM_CODE)               AS TEAM_NAME, 
						(SELECT COD_PUBLIC.PUB_VALUE 
						FROM   COD_PUBLIC 
						WHERE  PUB_TYPE = 'EMP.POSTYPE' 
								AND COD_PUBLIC.PUB_CODE = A.POS_TYPE)  AS POS_NAME, 
						(SELECT COD_PUBLIC.PUB_VALUE 
						FROM   COD_PUBLIC 
						WHERE  COD_PUBLIC.PUB_TYPE = 'EMP.DUTYTYPE' 
								AND COD_PUBLIC.PUB_CODE = A.DUTY_TYPE) AS DUTY_NAME, 
						ISNULL(C.USE_DAY,0) AS USE_DAY, 
						ISNULL(F.CAN_DAY, 0)                           AS CAN_DAY, 
						ROUND(ISNULL(CAST(CAST(ISNULL(C.USE_DAY, '0') AS FLOAT) / CAST( 
											ISNULL(F.CAN_DAY, '0') AS FLOAT) * 
												100 AS FLOAT), 0) ,1,1)   AS USE_PERCENT 
				FROM   EMP_MASTER A 
						LEFT JOIN (SELECT EMP_CODE, 
											SUM(HOLIDAY_USE_DAY)AS USE_DAY 
									FROM   EMP_HOLIDAY_HISTORY 
									WHERE  APPLY_YEAR = @APPLY_YEAR 
											AND HOLIDAY_TYPE = '1' AND APPLY_YN='Y'
									GROUP  BY EMP_CODE) AS C 
								ON A.EMP_CODE = C.EMP_CODE 
						LEFT JOIN (SELECT CAN_DAY, APPLY_YEAR, 
											EMP_CODE 
									FROM   EMP_HOLIDAY 
									WHERE  APPLY_YEAR = @APPLY_YEAR 
											AND HOLIDAY_TYPE = '1') AS F 
								ON A.EMP_CODE = F.EMP_CODE 
				WHERE  1 = 1 
					)G 
			WHERE  1 = 1 
			AND (CASE 
			WHEN ISNULL(@TEAM_CODE,'') = ''  THEN 1
			WHEN ISNULL(@TEAM_CODE,'')<> '' AND G.TEAM_CODE  = @TEAM_CODE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@POS_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@POS_TYPE,'')<> '' AND G.POS_TYPE  = @POS_TYPE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@DUTY_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@DUTY_TYPE,'')<> '' AND G.DUTY_TYPE  = @DUTY_TYPE THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@EMP_NAME,'') = ''  THEN 1
			WHEN ISNULL(@EMP_NAME,'')<> '' AND G.KOR_NAME  = @EMP_NAME THEN 1
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@EMP_CODE,'') = ''  THEN 1
			WHEN ISNULL(@EMP_CODE,'')<> '' AND G.EMP_CODE  = @EMP_CODE THEN 1 
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@WORK_TYPE,'') = ''  THEN 1
			WHEN ISNULL(@WORK_TYPE,'')<> '' AND G.WORK_TYPE  = @WORK_TYPE THEN 1 
			ELSE 0
			END) = 1
			AND (CASE 
			WHEN ISNULL(@APPLY_YEAR,'') = ''  THEN 1
			WHEN ISNULL(@APPLY_YEAR,'')<> '' AND G.APPLY_YEAR  = @APPLY_YEAR THEN 1 
			ELSE 0
			END) = 1		
		) H
			WHERE  H.ROWNUMBER  BETWEEN  @FROM AND @TO
			ORDER BY H.ROWNUMBER
		END
	END
END

GO
