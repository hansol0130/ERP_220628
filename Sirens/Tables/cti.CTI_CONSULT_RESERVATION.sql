USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CONSULT_RESERVATION](
	[CONSULT_RES_SEQ] [int] NOT NULL,
	[CONSULT_RES_DATE] [datetime] NOT NULL,
	[CONSULT_SEQ] [char](14) NULL,
	[CONSULT_TYPE] [varchar](10) NOT NULL,
	[EMP_CODE] [char](7) NOT NULL,
	[EMP_NAME] [varchar](20) NULL,
	[TEAM_CODE] [char](3) NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[INNER_NUMBER] [varchar](4) NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [nvarchar](20) NULL,
	[CUS_TEL] [varchar](20) NOT NULL,
	[CONSULT_RESULT] [varchar](1) NOT NULL,
	[CONSULT_RES_CONTENT] [nvarchar](2000) NULL,
	[RES_CODE] [varchar](12) NULL,
	[RESULT_CONSULT_SEQ] [varchar](14) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_CTI_CONSULT_RESERVATION] PRIMARY KEY CLUSTERED 
(
	[CONSULT_RES_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담예약SEQ' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_RES_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담예약시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_RES_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담등록ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담예약유형' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담원ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담원명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀/부서코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀/부서명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객전화번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CUS_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리여부' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약내용' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'CONSULT_RES_CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정작업자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_RESERVATION', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
