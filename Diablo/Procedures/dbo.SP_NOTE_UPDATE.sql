USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:권윤경
-- Create date: 2008-03-25
-- Description:	쪽지 삭제 및 카테고리이동 SP

CREATE PROCEDURE [dbo].[SP_NOTE_UPDATE]
@EMP_CODE VARCHAR(7),
@SEQ_NO VARCHAR(1000),
@CAT_SEQ_NO INT,
@TYPE CHAR(1), --S : 보낸쪽지 R:받은쪽지
@MODE CHAR(1) --U : 카테고리 이동 D:삭제
AS

BEGIN
		SET NOCOUNT OFF;
		DECLARE @SEQ INT;
		DECLARE @TEMP_SEQ VARCHAR(20);
		DECLARE @INDEX INT;
		DECLARE @TEMP_SEQ_LIST VARCHAR(1000);
		DECLARE @SPLIT_INDEX INT;

		SET @INDEX = CHARINDEX(',', @SEQ_NO);
		
		IF @INDEX=0
		BEGIN
			IF @MODE='D' 	--삭제일경우
			BEGIN
				IF @TYPE='S' --보낸쪽지 삭제일경우
				BEGIN
					SET @SPLIT_INDEX = CHARINDEX('|',@SEQ_NO);					
					UPDATE PUB_NOTE SET SEND_DEL_YN='Y' 
					WHERE EMP_CODE = RIGHT(@SEQ_NO, LEN(@SEQ_NO) - @SPLIT_INDEX)	
						AND SEQ_NO = LEFT(@SEQ_NO,@SPLIT_INDEX-1);
				END
				ELSE		--받은쪽지 삭제일경우
				BEGIN
					UPDATE PUB_NOTE SET DEL_YN='Y' WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@SEQ_NO;
				END
			END
			ELSE
			BEGIN
				IF @TYPE='S'--보낸쪽지 카테고리 이동일경우
				BEGIN
					SET @SPLIT_INDEX = CHARINDEX('|',@SEQ_NO);					
					UPDATE PUB_NOTE SET SEND_CAT_SEQ_NO=@CAT_SEQ_NO
					WHERE EMP_CODE = RIGHT(@SEQ_NO, LEN(@SEQ_NO) - @SPLIT_INDEX)	
						AND SEQ_NO = LEFT(@SEQ_NO,@SPLIT_INDEX-1);					
				END
				ELSE		--받은쪽지 카테고리 이동일 경우
				BEGIN
					UPDATE PUB_NOTE SET CAT_SEQ_NO=@CAT_SEQ_NO  WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@SEQ_NO;
				END				
			END
		END
		ELSE
		BEGIN
			SET @SEQ_NO = @SEQ_NO + ',';
			WHILE NOT (@INDEX=0)
				BEGIN
					
					SET @TEMP_SEQ = LEFT(@SEQ_NO, @INDEX-1); 
					SET @TEMP_SEQ_LIST = RIGHT(@SEQ_NO, LEN(@SEQ_NO) - @INDEX);
					
					
					IF @MODE='D' 	--삭제일경우
					BEGIN
						IF @TYPE='S' --보낸쪽지 삭제일경우
								BEGIN
									SET @SPLIT_INDEX = CHARINDEX('|',@TEMP_SEQ);					
									UPDATE PUB_NOTE SET SEND_DEL_YN='Y' 
									WHERE EMP_CODE = RIGHT(@TEMP_SEQ, LEN(@TEMP_SEQ) - @SPLIT_INDEX)	
										AND SEQ_NO = LEFT(@TEMP_SEQ,@SPLIT_INDEX-1);	
														
								END
						ELSE		--받은쪽지 삭제일경우
								BEGIN
									UPDATE PUB_NOTE SET DEL_YN='Y' WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
								END
					END
					ELSE
						BEGIN
							IF @TYPE='S'--보낸쪽지 카테고리 이동일경우
								BEGIN
									SET @SPLIT_INDEX = CHARINDEX('|',@TEMP_SEQ);					
									UPDATE PUB_NOTE SET SEND_CAT_SEQ_NO=@CAT_SEQ_NO 
									WHERE EMP_CODE = RIGHT(@TEMP_SEQ, LEN(@TEMP_SEQ) - @SPLIT_INDEX)	
										AND SEQ_NO = LEFT(@TEMP_SEQ,@SPLIT_INDEX-1);	
									--print @TEMP_SEQ
									--print RIGHT(@TEMP_SEQ, LEN(@TEMP_SEQ) - @SPLIT_INDEX)	
									--print LEFT(@TEMP_SEQ,@SPLIT_INDEX-1);		
								END
							ELSE		--받은쪽지 카테고리 이동일 경우
								BEGIN
									UPDATE PUB_NOTE SET CAT_SEQ_NO=@CAT_SEQ_NO  WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
								END				
						END

					SET @INDEX = CHARINDEX(',', @TEMP_SEQ_LIST);
					SET @SEQ_NO = @TEMP_SEQ_LIST
					--PRINT @INDEX
				END
		END
				
			
		
END

--		SET NOCOUNT OFF;
--		DECLARE @SEQ INT;
--		DECLARE @TEMP_SEQ VARCHAR(10);
--		DECLARE @INDEX INT;
--		DECLARE @TEMP_SEQ_LIST VARCHAR(1000);
--
--
--		SET @INDEX = CHARINDEX(',', @SEQ_NO);
--		
--		IF @INDEX=0
--			SET @INDEX = 2;SET @SEQ_NO = @SEQ_NO + ','
--
--
--		WHILE NOT (@INDEX=0)
--			BEGIN
--			
--				SET @TEMP_SEQ = LEFT(@SEQ_NO, @INDEX - 1); 
--				SET @TEMP_SEQ_LIST = RIGHT(@SEQ_NO, LEN(@SEQ_NO) - @INDEX);
--				
--			--	PRINT @TEMP_SEQ
--			--	PRINT @TEMP_SEQ_LIST
--
--					
--				IF @MODE='D' 	--삭제일경우
--				BEGIN
--					IF @TYPE='S' --보낸쪽지 삭제일경우
--							BEGIN
--								UPDATE PUB_NOTE SET SEND_DEL_YN='Y' WHERE NEW_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
--							END
--					ELSE		--받은쪽지 삭제일경우
--							BEGIN
--								UPDATE PUB_NOTE SET DEL_YN='Y' WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
--							END
--				END
--				ELSE
--					BEGIN
--						IF @TYPE='S'--보낸쪽지 카테고리 이동일경우
--							BEGIN
--							--	PRINT (@INDEX)
--								--	PRINT (@TEMP_SEQ)
--
--								UPDATE PUB_NOTE SET SEND_CAT_SEQ_NO=@CAT_SEQ_NO  WHERE NEW_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
--							END
--						ELSE		--받은쪽지 카테고리 이동일 경우
--							BEGIN
--								UPDATE PUB_NOTE SET CAT_SEQ_NO=@CAT_SEQ_NO  WHERE EMP_CODE=@EMP_CODE AND SEQ_NO=@TEMP_SEQ
--							END				
--					END
--
--				SET @INDEX = CHARINDEX(',', @TEMP_SEQ_LIST);
--				SET @SEQ_NO = @TEMP_SEQ_LIST
--			END

GO
