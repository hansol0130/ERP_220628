USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_UPDATE
■ DESCRIPTION				: 사내 IP관리 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec SP_IP_MANAGE_UPDATE @IP_TYPE=1,@CONNECT_CODE='2013052',@IPADDRESS='123.4567',@CH_NUM=0,@RECORD_YN='Y'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-11		정지용			최초생성
   2014-12-04		정지용			CTI 사용유무 추가
   2016-09-07		정지용			관리번호, 비고 추가
   2017-04-27		정지용			오피스, 한글 버젼 추가
   2017-06-02		박형만			등록안된 IP_TYPE 이 있을경우 추가해주기 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_UPDATE]
	@IP_TYPE INT, -- 1 :PC, 2 : 전화기
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

	--등록안된 IP_TYPE 
	IF NOT EXISTS ( SELECT * FROM IP_MASTER WITH(NOLOCK)
		WHERE CONNECT_CODE = @CONNECT_CODE AND IP_TYPE = @IP_TYPE
	)
	BEGIN
		DECLARE @IP_CODE INT
		SELECT TOP 1 @IP_CODE = ISNULL(MAX(IP_CODE),0) + 1 FROM IP_MASTER WITH (NOLOCK)
		--추가해주기 
		INSERT INTO IP_MASTER (
			IP_TYPE, IP_CODE, CONNECT_CODE, IP_NUMBER, COM_NUMBER, COM_REMARK, COM_OFFICE_VER, COM_HANGLE_VER
		) 
		VALUES (
			@IP_TYPE, @IP_CODE, @CONNECT_CODE, @IPADDRESS, @COM_NUMBER, @COM_REMARK, @COM_OFFICE_VER, @COM_HANGLE_VER
		)	
	END 
	ELSE 
	BEGIN
		--등록되었으면 수정
		UPDATE IP_MASTER SET 
			IP_NUMBER = @IPADDRESS, COM_NUMBER = @COM_NUMBER, COM_REMARK = @COM_REMARK, COM_OFFICE_VER = @COM_OFFICE_VER, COM_HANGLE_VER = @COM_HANGLE_VER
		WHERE CONNECT_CODE = @CONNECT_CODE AND IP_TYPE = @IP_TYPE
	END 

	IF @RECORD_YN IS NOT NULL
	BEGIN
		UPDATE EMP_MASTER_damo SET CH_NUM = @CH_NUM, RECORD_YN = @RECORD_YN WHERE EMP_CODE = @CONNECT_CODE
	END

	IF @CTI_YN IS NOT NULL
	BEGIN
		UPDATE EMP_MASTER_damo SET CTI_USE_YN = @CTI_YN WHERE EMP_CODE = @CONNECT_CODE
	END

END
GO
