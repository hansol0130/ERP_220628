USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_RES_AIR_MASTER_UPDATE
■ DESCRIPTION				: BTMS ERP 항공 예약 마스터 정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-20		김성호			최초생성
   2016-09-12		박형만			PNR_CODE 수정가능하도록 
   2016-09-20		박형만			PNR_INFO 변경시 PNR 수정날짜 업데이트 
   2016-12-16		박형만			RES_AIR_DETAIL 의 스케쥴 수정 
   2017-06-14		박형만			RES_MASTER 의 출 도착일 변경 
   2017-06-15		정지용			DEP_DATE convert 잘못 되어있는거 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_RES_AIR_MASTER_UPDATE]
	@RES_CODE			CHAR(12),
	@PRO_NAME			NVARCHAR(100),
	@COMM_RATE			NUMERIC(4,2),
	@COMM_AMT			DECIMAL,
	@LAST_PAY_DATE		DATETIME,
	@TTL_DATE			DATETIME,
	@PNR_INFO			NVARCHAR(MAX),
	@EDT_CODE			CHAR(7),

	@PNR_CODE1			VARCHAR(20) = NULL ,
	@PNR_CODE2			VARCHAR(20) = NULL ,


	@DEP_DEP_DATE	DATETIME = NULL ,
	@DEP_ARR_DATE	DATETIME = NULL ,	
	@DEP_DEP_TIME	CHAR(5) = NULL ,		
	@DEP_ARR_TIME	CHAR(5) = NULL ,

	@DEP_DEP_AIRPORT_CODE	CHAR(3) = NULL ,			
	@DEP_ARR_AIRPORT_CODE	CHAR(3) = NULL ,

	@ARR_DEP_DATE	DATETIME = NULL ,	
	@ARR_ARR_DATE	DATETIME = NULL ,			
	@ARR_DEP_TIME	CHAR(5) = NULL ,	
	@ARR_ARR_TIME	CHAR(5) = NULL ,

	@ARR_DEP_AIRPORT_CODE	CHAR(3) = NULL ,					
	@ARR_ARR_AIRPORT_CODE	CHAR(3) = NULL ,

	@ERROR_MSG			VARCHAR(1000) OUTPUT
AS 
BEGIN

BEGIN TRY
	BEGIN TRAN

	DECLARE @OLD_PNR_INFO NVARCHAR(MAX) 
	SELECT @OLD_PNR_INFO = PNR_INFO FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @RES_CODE 

	UPDATE RES_MASTER_damo  SET
		PRO_NAME = @PRO_NAME, COMM_RATE = @COMM_RATE, COMM_AMT = @COMM_AMT, LAST_PAY_DATE = @LAST_PAY_DATE, PNR_INFO = @PNR_INFO, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE(),
		DEP_DATE = CONVERT(VARCHAR(10),@DEP_DEP_DATE,121) + ' ' +@DEP_DEP_TIME +':00', 
		ARR_DATE = CONVERT(VARCHAR(10),@ARR_ARR_DATE,121) + ' ' +@ARR_ARR_TIME +':00'
	WHERE RES_CODE = @RES_CODE;

	UPDATE RES_AIR_DETAIL SET TTL_DATE = @TTL_DATE
		,PNR_CODE1 = @PNR_CODE1
		,PNR_CODE2 = @PNR_CODE2 
		,PNR_MODIFY_DATE =  (CASE WHEN @PNR_INFO <> @OLD_PNR_INFO THEN GETDATE() ELSE PNR_MODIFY_DATE END )  -- PNR 내용 변경시에만 수정일 변경 

		,DEP_DEP_DATE = @DEP_DEP_DATE,
		DEP_ARR_DATE = @DEP_ARR_DATE,	
		DEP_DEP_TIME = @DEP_DEP_TIME,		
		DEP_ARR_TIME = @DEP_ARR_TIME,

		DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE,						
		DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE,

		ARR_DEP_DATE = @ARR_DEP_DATE,	
		ARR_ARR_DATE = @ARR_ARR_DATE,		
		ARR_DEP_TIME = @ARR_DEP_TIME,
		ARR_ARR_TIME = @ARR_ARR_TIME,

		ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE,						
		ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE

	WHERE RES_CODE = @RES_CODE;

	COMMIT TRAN
END TRY
BEGIN CATCH

	SELECT @ERROR_MSG = ERROR_MESSAGE();

	ROLLBACK TRAN
END CATCH

END
GO
