USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DSR_ISSUE_TASF_LIST_SELECT
■ DESCRIPTION					: DSR 발권/TASF 리스트 검색
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :

EXEC ZP_DSR_ISSUE_TASF_LIST_SELECT @START_DATE='2022-04-01', @END_DATE='2022-04-02'

EXEC ZP_DSR_ISSUE_TASF_LIST_SELECT @START_DATE='2022-04-10', @END_DATE='2022-04-10', @SEARCH_TYPE=1

EXEC ZP_DSR_ISSUE_TASF_LIST_SELECT @START_DATE='2022-04-10', @END_DATE='2022-04-10', @TICKET='3331786094'

EXEC ZP_DSR_ISSUE_TASF_LIST_SELECT @START_DATE='2022-04-10', @END_DATE='2022-04-10', @PRO_CODE='GTR100-2210174732'

■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-04-13		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DSR_ISSUE_TASF_LIST_SELECT]
	@START_DATE		DATE,					-- 조회시작
	@END_DATE		DATE,					-- 조회종료
	@SEARCH_TYPE	CHAR(1) = 0,			-- 0: 발권일, 1: 출발일
	@TICKET			VARCHAR(10) = '',		-- 티켓번호
	@PRO_CODE		VARCHAR(20) = ''		-- 행사번호
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT @END_DATE = DATEADD(DD ,1 ,@END_DATE);
	
	SELECT CONVERT(DATE ,DT.ISSUE_DATE) AS [ISSUE_DATE]	-- 발권일
	      ,ISNULL(MA100.PNR_SEQNO, '') AS [PNR_SEQNO] -- 일련번호
	      ,(CASE WHEN RMD.RES_STATE IN (4 ,5 ,6) THEN '정상' WHEN RMD.RES_STATE = 7 THEN '환불' WHEN RMD.RES_STATE = 8 THEN '이동' WHEN RMD.RES_STATE = 9 THEN '취소' ELSE '기타' END) AS [STATE_NAME] -- 예약상태
	      ,DT.RES_CODE AS [RES_CODE] -- 예약번호
	      ,DT.PRO_CODE AS [PRO_CODE] -- 행사번호
	      ,CP1.PUB_VALUE AS [PROVIDER] -- 예약구분명
	      ,ISNULL(AM.KOR_NAME ,'') AS [AGT_NAME] -- 거래처
	      ,CONVERT(DATE ,DT.[START_DATE]) AS [START_DATE] -- 출발일
	      ,CONVERT(DATE ,DT.END_DATE) AS [END_DATE] -- 도착일
	      ,DT.AIRLINE_CODE AS [AIRLINE_CODE] -- 항공사
	      ,DT.AIRLINE_NUM AS [AIRLINE_NUM] -- 항공편
	      ,DT.TICKET AS [TICKET] -- 티켓번호
	      ,DT.PAX_NAME AS [NAME] -- NAME
	      ,RMD.RES_NAME AS [RES_NAME] -- 예약자명
	      ,DT.ROUTING AS [ROUTING] -- 여정
	      ,ISNULL(DT.AIR_CLASS ,'') AS [AIR_CLASS] -- 발권CLS
	      ,(CASE DT.FOP WHEN 1 THEN '카드' WHEN 2 THEN '현금' WHEN 3 THEN '복합' ELSE '없음' END) AS [FOP] -- 결제수단
	      ,DT.FARE AS [FARE]
	      ,DT.DISCOUNT AS [D/C]
	      ,DT.NET_PRICE AS [NET]
	      ,DT.TAX_PRICE AS [TAX]
	      ,(ISNULL(DT.NET_PRICE ,0) + ISNULL(DT.TAX_PRICE ,0)) AS [TOTAL]
	      ,DT.CASH_PRICE AS [CASH] -- 현금
	      ,DT.CARD_PRICE AS [CARD] -- 카드
	      ,ISNULL(DT.CARD_AUTH ,'') AS [CARD_AUTH] -- AIR승인번호
	      ,ISNULL(DTA.TOTAL_PRICE ,0) AS [TASF_PRICE] -- TASF
	      ,ISNULL(DTA.CARD_AUTH ,'') AS [TASF_AUTH] -- TASF승인번호
	      ,(ISNULL(DT.NET_PRICE ,0) + ISNULL(DT.TAX_PRICE ,0) + ISNULL(DTA.TOTAL_PRICE ,0)) AS [TOTAL_PRICE] -- 총금액
	      ,RCD.INS_PRICE AS [INS_PRICE] -- 보험료
	      ,EMD.KOR_NAME AS [KOR_NAME] -- 판매자
	      ,ISNULL(RCD.ETC_REMARK ,'') AS [ETC_REMARK] -- 비고
	       --DT.*
	FROM   dbo.DSR_TICKET DT
	       LEFT JOIN dbo.RES_MASTER_damo RMD
	            ON  DT.RES_CODE = RMD.RES_CODE
	       LEFT JOIN dbo.RES_CUSTOMER_damo RCD
	            ON  DT.RES_CODE = RCD.RES_CODE
	                AND DT.RES_SEQ_NO = RCD.SEQ_NO
	       LEFT JOIN dbo.EMP_MASTER_damo EMD
	            ON  DT.SALE_CODE = EMD.EMP_CODE
	       LEFT JOIN dbo.DSR_TASF DTA
	            ON  DT.TICKET = DTA.PARENT_TICKET
	       LEFT JOIN dbo.AGT_MASTER AM
	            ON  RMD.SALE_COM_CODE = AM.AGT_CODE
	       LEFT JOIN dbo.COD_PUBLIC CP1
	            ON  RMD.PROVIDER = CP1.PUB_CODE
	                AND CP1.PUB_TYPE = 'RES.AGENT.TYPE'
	       LEFT JOIN interface.TB_VGT_MA100 MA100
	            ON  DT.RES_CODE = MA100.IF_SYS_RSV_NO
	WHERE  (CASE WHEN @SEARCH_TYPE = 1 OR @TICKET <> '' OR @PRO_CODE <> '' THEN 1 WHEN DT.ISSUE_DATE >= @START_DATE AND DT.ISSUE_DATE < @END_DATE THEN 1 ELSE 0 END) = 1
	       AND (CASE WHEN @SEARCH_TYPE = 0 OR @TICKET <> '' OR @PRO_CODE <> '' THEN 1 WHEN DT.[START_DATE] >= @START_DATE AND DT.[START_DATE] < @END_DATE THEN 1 ELSE 0 END) = 1
	       AND (CASE WHEN @TICKET = '' THEN 1 WHEN DT.TICKET = @TICKET THEN 1 ELSE 0 END) = 1
	       AND (CASE WHEN @PRO_CODE = '' THEN 1 WHEN DT.PRO_CODE = @PRO_CODE THEN 1 ELSE 0 END) = 1;
END


GO
