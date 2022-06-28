USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_MA200](
	[PNR_SEQNO] [int] NOT NULL,
	[PAY_RQ_SEQNO] [int] NOT NULL,
	[DATA_FLAG] [varchar](10) NOT NULL,
	[CONFM_USR_ID] [varchar](50) NULL,
	[CONFM_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[PNR_SEQNO] ASC,
	[PAY_RQ_SEQNO] ASC,
	[DATA_FLAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_MA200] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [CONFM_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA200', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA200', @level2type=N'COLUMN',@level2name=N'PAY_RQ_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'데이터자료 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA200', @level2type=N'COLUMN',@level2name=N'DATA_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA200', @level2type=N'COLUMN',@level2name=N'CONFM_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA200', @level2type=N'COLUMN',@level2name=N'CONFM_DTM'
GO
