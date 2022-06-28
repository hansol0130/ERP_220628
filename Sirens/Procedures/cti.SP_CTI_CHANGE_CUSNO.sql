USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_CTI_CHANGE_CUSNO]
■ DESCRIPTION				:  고객번호 변경 
■ INPUT PARAMETER			:  
@OLD_CUSNO					:기존 고객번호
@NEW_CUSNO					: 변경 고객번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec  SP_CTI_CHANGE_CUSNO 1111,'홍길동',2222,'홍길동1'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-02-12		박노민			최초생성
   
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CHANGE_CUSNO]
@OLD_CUSNO INT, 
@NEW_CUSNO INT,
@NEW_CUSNAME varchar(20)
WITH EXEC AS CALLER
AS
BEGIN
	BEGIN TRAN

	SET NOCOUNT ON
	
	Declare @strError int

	-- 상담이력
    update sirens.cti.CTI_CONSULT set CUS_NO = @NEW_CUSNO, CUS_NAME = @NEW_CUSNAME WHERE CUS_NO = @OLD_CUSNO;

	-- 고객전화번호 별 고객번호
	update sirens.cti.CTI_CONSULT_CUS_TEL set CUS_NO = @NEW_CUSNO WHERE CUS_NO = @OLD_CUSNO;

	-- 고객약속
    update sirens.cti.CTI_CONSULT_RESERVATION set CUS_NO = @NEW_CUSNO, CUS_NAME = @NEW_CUSNAME WHERE CUS_NO = @OLD_CUSNO;

	-- 고객평가
	update sirens.cti.CTI_CUS_ESTI_MASTER set CUS_NO = @NEW_CUSNO WHERE CUS_NO = @OLD_CUSNO;

	-- 고객평가
	update sirens.cti.CTI_CUS_ESTI_LIST set CUS_NO = @NEW_CUSNO WHERE CUS_NO = @OLD_CUSNO;
	
	Set @strError = @@Error
   
	If (@strError<> 0)
	  Begin
	   RollBack Tran
	  End
	Else
	  Begin
	   Commit Tran
	  End

	SET NOCOUNT OFF

END
GO
