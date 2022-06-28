USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_DETAIL_INSERT
■ DESCRIPTION				: 수배 인보이스 디테일 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		
	exec XP_ARG_DETAIL_INSERT 0, 1, '수배요청【오키드홀리데이/4명출발】 위해+장보고유적지/탕박온천 3일_아시아나 연합', '수배요청 수배요청 <br> ㅁㅁㅁㅁㅁㅁㅁㅁㅁ', 0, 2, 1, 0, 0, NULL, NULL, NULL, 0, '9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-02-04		이동호			비고:ETC_REMARK 컬럼 추가 
   2014-03-25		김성호			기본키 변경
   2014-04-07		김성호			NEW_CODE 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_DETAIL_INSERT]
	@ARG_CODE VARCHAR(12),
	@GRP_SEQ_NO INT,
	@INV_SEQ_NO INT,
	@ADT_PRICE INT,
	@CHD_PRICE INT,
	@INF_PRICE INT,
	@FOC INT,
	@ETC_REMARK VARCHAR(1000)
AS 
BEGIN

	INSERT INTO ARG_INVOICE_DETAIL
           (ARG_CODE
		   ,GRP_SEQ_NO
           ,INV_SEQ_NO
           ,ADT_PRICE
           ,CHD_PRICE
           ,INF_PRICE
           ,FOC
		   ,ETC_REMARK)
	VALUES
           (@ARG_CODE
		   ,@GRP_SEQ_NO
           ,@INV_SEQ_NO
           ,@ADT_PRICE
           ,@CHD_PRICE
           ,@INF_PRICE
           ,@FOC
		   ,@ETC_REMARK)
END 


GO
