USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CONSULT](
	[CONSULT_SEQ] [char](14) NOT NULL,
	[CONSULT_DATE] [datetime] NOT NULL,
	[CONSULT_CALL_TYPE] [char](1) NOT NULL,
	[DURATION_TIME] [smallint] NOT NULL,
	[EMP_CODE] [char](7) NOT NULL,
	[EMP_NAME] [varchar](20) NULL,
	[TEAM_CODE] [char](3) NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[INNER_NUMBER] [varchar](4) NULL,
	[CUS_TYPE] [char](1) NOT NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [nvarchar](20) NULL,
	[CUS_TEL] [varchar](20) NOT NULL,
	[RES_CODE] [char](12) NULL,
	[CONSULT_TYPE] [varchar](10) NOT NULL,
	[CONSULT_CONTENT] [text] NULL,
	[POINT_YN] [char](1) NULL,
	[CONSULT_RESULT] [char](1) NULL,
	[SMS_SEND_YN] [char](1) NULL,
	[FAX_SEND_YN] [char](1) NULL,
	[CONSULT_FILE_NAME] [varchar](30) NULL,
	[SAVE_TYPE] [char](1) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[STT_FILE_NAME] [varchar](30) NULL,
 CONSTRAINT [PK_CTI_CONSULT] PRIMARY KEY CLUSTERED 
(
	[CONSULT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담등록ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담소요시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'DURATION_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담원ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담원명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀/부서코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀/부서명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객구분' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CUS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객전화번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CUS_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담유형' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담내용' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담처리결과' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS전송여부' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'SMS_SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX전송여부' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'FAX_SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'녹취파일명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CONSULT_FILE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담저장유형(1:첫저장, 2:전환저장, 8:긴급저장, 9:정상저장)' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'SAVE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정작업자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
