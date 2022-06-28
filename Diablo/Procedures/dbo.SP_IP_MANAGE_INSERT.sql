USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_INSERT
■ DESCRIPTION				: 사내 IP관리
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-11		정지용			최초생성
   2014-12-04		정지용			CTI 사용유무 추가
   2016-05-20		김성호			동일 IP_TYPE에 동일 사번 등록 금지
   2016-09-07		정지용			동일 관리번호 등록 금지 및 관리번호, 비고 추가
   2017-04-27		정지용			오피스, 한글 버젼 추가
   2017-06-02		박형만			같은 @COM_NUMBER 있으면 안들어가는 버그 현상 주석처리  
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_INSERT]
 	@IP_TYPE  INT, -- 1 :PC, 2 : 전화기
	@CONNECT_CODE VARCHAR(10),
	@IPADDRESS VARCHAR(15),
	@CH_NUM	INT,
	@RECORD_YN CHAR(1),
	@CTI_YN CHAR(1),
	@COM_NUMBER VARCHAR(10),
	@COM_REMARK VARCHAR(20),
	@COM_OFFICE_VER VARCHAR(10),
	@COM_HANGLE_VER VARCHAR(10)
AS 
BEGIN
	SET NOCOUNT OFF;


	DECLARE @IP_CODE INT
	SELECT TOP 1 @IP_CODE = ISNULL(MAX(IP_CODE),0) + 1 FROM IP_MASTER WITH (NOLOCK)

	IF NOT EXISTS(SELECT 1 FROM IP_MASTER WITH(NOLOCK) WHERE IP_TYPE = @IP_TYPE AND CONNECT_CODE = @CONNECT_CODE)
	BEGIN
		--IF EXISTS(SELECT 1 FROM IP_MASTER WITH(NOLOCK) WHERE COM_NUMBER = @COM_NUMBER AND @COM_NUMBER IS NOT NULL AND @COM_NUMBER <> '')
		--BEGIN 
		--	RETURN;
		--END
		INSERT INTO IP_MASTER (
			IP_TYPE, IP_CODE, CONNECT_CODE, IP_NUMBER, COM_NUMBER, COM_REMARK, COM_OFFICE_VER, COM_HANGLE_VER
		) 
		VALUES (
			@IP_TYPE, @IP_CODE, @CONNECT_CODE, @IPADDRESS, @COM_NUMBER, @COM_REMARK, @COM_OFFICE_VER, @COM_HANGLE_VER
		)	

		IF @RECORD_YN IS NOT NULL
		BEGIN
			UPDATE EMP_MASTER_damo SET CH_NUM = @CH_NUM, RECORD_YN = @RECORD_YN WHERE EMP_CODE = @CONNECT_CODE
		END

		IF @CTI_YN IS NOT NULL
		BEGIN
			UPDATE EMP_MASTER_damo SET CTI_USE_YN = @CTI_YN WHERE EMP_CODE = @CONNECT_CODE
		END

	END

END
GO
