USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_DOCU_STAT]  
(  
   @SLIP_MK_DAY  VARCHAR(8),  
   @SLIP_MK_SEQ  SMALLINT  
)  
RETURNS VARCHAR(10)  
  
AS  

BEGIN

	DECLARE @ROW_ID NVARCHAR(40),				-- FI_ADOCU 키
			@CD_COMPANY	NVARCHAR (7),			-- 회사코드 3000 고정
			@SLIP_STATE VARCHAR(1),				-- 승인 여부 체크
			@SLIP_CNT INT,						-- 전표 세부 항목 수
			@DOCU_STATE VARCHAR(10)				-- 리턴값 (자동전표 상태)

	SELECT	@ROW_ID = ('AD' + @SLIP_MK_DAY + RIGHT(('0000' + CONVERT(VARCHAR(5), @SLIP_MK_SEQ)), 5)),
			@CD_COMPANY	= '3000'


	SELECT	@SLIP_STATE = MAX(TP_DOCU),			-- 전표 상태 'N' 미처리, 'Y' 처리
			@SLIP_CNT = COUNT(*)				-- 존재유무
	FROM	DZDB.NEOE.NEOE.FI_ADOCU
	WHERE	ROW_ID = @ROW_ID					-- 처리일자
			AND CD_COMPANY = @CD_COMPANY

	IF @SLIP_STATE > 0
	BEGIN
		SET @DOCU_STATE = @SLIP_STATE
	END
	ELSE
	BEGIN
		SET @DOCU_STATE = 'N'
	END

	RETURN @DOCU_STATE
  
--DECLARE @CD_NM    VARCHAR(10),  
--        @FIX_YN   CHAR(1),  
--        @SLIP_CNT SMALLINT  
  
-- SELECT @FIX_YN = MAX(DOCU_STAT),  
--        @SLIP_CNT = COUNT(*)  
--   FROM DZDB.DZAIS.DZAIS.AUTODOCU  WITH(NOLOCK)  
--  WHERE WRITE_DATE = @SLIP_MK_DAY  
--    AND DATA_NO = @SLIP_MK_SEQ  
  
--IF @SLIP_CNT > 0   
--   IF @FIX_YN = '1'  
--      SET @CD_NM = 'F'  
--   ELSE  
--      SET @CD_NM = 'Y'  
--ELSE  
--   SET @CD_NM = 'N'  
  
--RETURN @CD_NM  
  
END  
  
GO
