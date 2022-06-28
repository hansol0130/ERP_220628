USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_FAX_INSERT_MULTI
■ DESCRIPTION				: 팩스 다중 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_FAX_INSERT_MULTI ''
■ MEMO						: 기존 for문 돌리면서 건건히 하던거 쿼리로 통합
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-03-08		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_FAX_INSERT_MULTI]
	@FAX_INFO XML
AS
BEGIN
BEGIN TRAN
	BEGIN TRY	
		DECLARE @UQ_FAX_SEQ INT;
		DECLARE @TMP_FAX_INFO TABLE
		(
			SEQ INT IDENTITY(1,1),
			FAX_SEQ  VARCHAR(17),
			FAX_TYPE VARCHAR(1),
			SEND_TYPE VARCHAR(1),
			[SUBJECT] VARCHAR(100),
			SEND_NUMBER1 VARCHAR(4),
			SEND_NUMBER2 VARCHAR(4),
			SEND_NUMBER3 VARCHAR(4),
			RESERVE_DATE DATETIME,			
			RESERVE_YN VARCHAR(1),
			NEW_DATE DATETIME,
			NEW_CODE VARCHAR(7),
			NEW_NAME VARCHAR(20),
			PAGE_COUNT INT,
			FAX_GROUP INT,
			READ_YN CHAR(1)
		);	
		/* 순번 따오기 */
		DECLARE @OUTPUT_SEQ INT;
		DECLARE @UQ_STR_SEQ VARCHAR(15);
		EXEC SP_COD_GETSEQ 'FAX', @OUTPUT_SEQ OUTPUT;
	
		-- 날짜 8자리 +  순번 7자리 = 15자리
		SELECT @UQ_STR_SEQ = CONVERT(VARCHAR(8), GETDATE(), 112) + REPLICATE('0', 7 - LEN(CONVERT(VARCHAR, @OUTPUT_SEQ))) + CONVERT(VARCHAR, @OUTPUT_SEQ);


		/* ######### TEMP 테이블에 팩스 저장 #########*/	
		WITH FAX_LIST AS
		(
			SELECT
				  DENSE_RANK() OVER (ORDER BY col) AS [SEQ]
				, @UQ_STR_SEQ + REPLICATE('0', 2 - LEN(CONVERT(VARCHAR, DENSE_RANK() OVER (ORDER BY col)))) + CONVERT(VARCHAR,DENSE_RANK() OVER (ORDER BY col)) AS FAX_SEQ
				, t1.col.value('./FaxType[1]', 'VARCHAR(1)') as [FAX_TYPE]
				, t1.col.value('./SendType[1]', 'VARCHAR(1)') as [SEND_TYPE]
				, t1.col.value('./Subject[1]', 'VARCHAR(100)') as [SUBJECT]
				, t1.col.value('./SendNumber1[1]', 'VARCHAR(4)') as [SEND_NUMBER1]
				, t1.col.value('./SendNumber2[1]', 'VARCHAR(4)') as [SEND_NUMBER2]
				, t1.col.value('./SendNumber3[1]', 'VARCHAR(4)') as [SEND_NUMBER3]
				, t1.col.value('./IsReserve[1]', 'varchar(10)') as [RESERVE_YN]
				, t1.col.value('./RESERVE_DATE[1]', 'DATETIME') as [RESERVE_DATE]
				, t1.col.value('./NewCode[1]', 'VARCHAR(7)') as [NEW_CODE]
				, t1.col.value('./NewName[1]', 'VARCHAR(20)') as [NEW_NAME]
				, t1.col.value('./PageCount[1]', 'INT') as [PAGE_COUNT]
				, t1.col.value('./FaxGroup[1]', 'INT') as [FAX_GROUP]
			FROM @FAX_INFO.nodes('ArrayOfFaxRS/FaxRS') as t1(col)
		)		
		INSERT INTO @TMP_FAX_INFO(
			FAX_SEQ,FAX_TYPE,SEND_TYPE,[SUBJECT],
			SEND_NUMBER1,SEND_NUMBER2,SEND_NUMBER3,
			RESERVE_YN,RESERVE_DATE,NEW_CODE,NEW_DATE,NEW_NAME,PAGE_COUNT,FAX_GROUP,READ_YN)
		SELECT 
			FAX_SEQ, FAX_TYPE,SEND_TYPE,[SUBJECT],
			SEND_NUMBER1,SEND_NUMBER2,SEND_NUMBER3,
			CASE WHEN RESERVE_YN = 'false' THEN 'N' ELSE 'Y' END,
			RESERVE_DATE,NEW_CODE,GETDATE(),NEW_NAME,PAGE_COUNT,FAX_GROUP,'N'
		FROM FAX_LIST ORDER BY SEQ;


		/* XML 데이타가 TEMP테이블에 들어가지 않았다면 롤백 */
		IF @@ROWCOUNT = 0
		BEGIN			
			ROLLBACK TRAN;
			SELECT '';
			RETURN;
		END


		/* ######### FAX_MASTER에 저장 #########*/
		INSERT INTO FAX_MASTER (
			FAX_SEQ,FAX_TYPE,SEND_TYPE,[SUBJECT],
			SEND_NUMBER1,SEND_NUMBER2,SEND_NUMBER3,
			RESERVE_YN,RESERVE_DATE,NEW_CODE,NEW_DATE,NEW_NAME,PAGE_COUNT,FAX_GROUP,READ_YN)
		SELECT
			FAX_SEQ,FAX_TYPE,SEND_TYPE,[SUBJECT],
			SEND_NUMBER1,SEND_NUMBER2,SEND_NUMBER3,
			RESERVE_YN,RESERVE_DATE,NEW_CODE,NEW_DATE,NEW_NAME,PAGE_COUNT,FAX_GROUP,READ_YN
		FROM @TMP_FAX_INFO ORDER BY SEQ;
		

		/* ######### 팩스 첨부파일 저장 ( 파일명과 파일경로는 업로드 후에 UPDATE ) #########*/	
		WITH FAX_FILE_LIST AS
		(
			SELECT
				DENSE_RANK() OVER (ORDER BY col1) AS [SEQ]
				, t2.col2.value('./FileSeq[1]', 'INT') as [FILE_SEQ]
			FROM @FAX_INFO.nodes('ArrayOfFaxRS/FaxRS') as t1 (col1)
			CROSS APPLY t1.col1.nodes('./FileList/FileRS') AS t2 (col2)
		)
		INSERT INTO FAX_FILE ( FILE_SEQ, FAX_SEQ )
		SELECT B.FILE_SEQ, A.FAX_SEQ FROM @TMP_FAX_INFO A
		INNER JOIN FAX_FILE_LIST B ON A.SEQ = B.SEQ;

		/* ######### 팩스 받는사람 입력 #########*/	
		WITH FAX_RCV_LIST AS
		(
			SELECT 
				DENSE_RANK() OVER (ORDER BY col1) AS [SEQ]
				, t2.col2.value('./RcvSeq[1]', 'INT') as [RCV_SEQ]
				, t2.col2.value('./ReceiveNumber1[1]', 'VARCHAR(4)') as [RCV_NUMBER1]
				, t2.col2.value('./ReceiveNumber2[1]', 'VARCHAR(4)') as [RCV_NUMBER2]
				, t2.col2.value('./ReceiveNumber3[1]', 'VARCHAR(4)') as [RCV_NUMBER3]
				, t2.col2.value('./KoreanName[1]', 'VARCHAR(20)') as [KOR_NAME]
				, t2.col2.value('./RecieveEmployeeCode[1]', 'CHAR(7)') as [RCV_EMP_CODE]
			FROM @FAX_INFO.nodes('ArrayOfFaxRS/FaxRS') as t1 (col1)
			CROSS APPLY t1.col1.nodes('./ReceiveList/FaxReceiveRS') AS t2 (col2)
		)
		INSERT INTO FAX_RECEIVE
		(RCV_SEQ,FAX_SEQ,RCV_NUMBER1,RCV_NUMBER2,RCV_NUMBER3,KOR_NAME,RCV_EMP_CODE)
		SELECT 
			B.RCV_SEQ, A.FAX_SEQ, B.RCV_NUMBER1, B.RCV_NUMBER2, B.RCV_NUMBER3, B.KOR_NAME, B.RCV_EMP_CODE
		FROM @TMP_FAX_INFO A
		INNER JOIN FAX_RCV_LIST B ON A.SEQ = B.SEQ


		IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRAN;
			/* 성공시 팩스 번호 콤마 구분 리턴 */
			SELECT STUFF( ( SELECT ',' + FAX_SEQ FROM @TMP_FAX_INFO FOR XML PATH('') ), 1, 1, '');
		END		
	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;
			SELECT '';
		END		
	END CATCH
END
GO
