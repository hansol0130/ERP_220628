USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_SS100](
	[API_TRANS_SEQNO] [int] IDENTITY(1,1) NOT NULL,
	[API_ID] [varchar](50) NOT NULL,
	[PNR_SEQNO] [int] NOT NULL,
	[RESPNS_SUCCESS_YN] [varchar](1) NOT NULL,
	[RESPNS_CD] [varchar](10) NULL,
	[RQ] [text] NULL,
	[RS] [text] NULL,
	[REG_USR_ID] [varchar](50) NOT NULL,
	[REG_DTM] [varchar](14) NOT NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[API_TRANS_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_SS100] ADD  DEFAULT ('N') FOR [RESPNS_SUCCESS_YN]
GO
ALTER TABLE [interface].[TB_VGT_SS100] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'API 전송 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'API_TRANS_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'API ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'API_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'응답 성공 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'RESPNS_SUCCESS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'응답 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'RESPNS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RQ' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'RQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RS' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'RS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'API 연동이력' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_SS100'
GO
