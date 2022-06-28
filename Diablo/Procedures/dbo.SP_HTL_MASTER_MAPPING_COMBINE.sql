USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_HTL_MASTER_MAPPING_COMBINE
- 기 능 : 중복 호텔 합치기 ( 제거 ) 
====================================================================================
	참고내용
====================================================================================
SP_HTL_MASTER_MAPPING_COMBINE 'AHH30733', 'AHS00066'  
====================================================================================
	변경내역
====================================================================================
- 2011-10-27 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_HTL_MASTER_MAPPING_COMBINE]
	@ORG_MASTER_CODE VARCHAR(20), --원본호텔
	@TRG_MASTER_CODE VARCHAR(20) --없앨호텔
AS 
SET NOCOUNT ON 

DECLARE @STATE_INFO VARCHAR(1000)
SET @STATE_INFO =  '원본호텔:' + @ORG_MASTER_CODE + CHAR(13) +'삭제호텔:' + @TRG_MASTER_CODE  + CHAR(13)


BEGIN TRAN
UPDATE HTL_CONNECT
SET MASTER_CODE = @ORG_MASTER_CODE
WHERE MASTER_CODE = @TRG_MASTER_CODE 

SET @STATE_INFO = @STATE_INFO + @TRG_MASTER_CODE +'--> '+@ORG_MASTER_CODE+ '로 업데이트 완료'   + CHAR(13)
 
UPDATE HTL_MASTER
SET SHOW_YN = 'N'
WHERE MASTER_CODE = @TRG_MASTER_CODE 

SET @STATE_INFO = @STATE_INFO +  @TRG_MASTER_CODE + '삭제완료(SHOW_YN=''N'')' + CHAR(13)
COMMIT TRAN 

SELECT @STATE_INFO
GO
