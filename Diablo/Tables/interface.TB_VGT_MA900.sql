USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_MA900](
	[LINK_NO] [int] IDENTITY(1,1) NOT NULL,
	[PNR_SEQNO] [int] NOT NULL,
	[SYNC_TYPE] [varchar](20) NULL,
	[IN_DATE] [datetime] NULL,
	[OUT_DATE] [datetime] NULL,
	[AUTO_YN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[LINK_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_MA900] ADD  CONSTRAINT [DF_TB_VGT_MA900_IN_DATE]  DEFAULT (getdate()) FOR [IN_DATE]
GO
ALTER TABLE [interface].[TB_VGT_MA900] ADD  DEFAULT ('Y') FOR [AUTO_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LINK 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'LINK_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SYNC 타입' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'SYNC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IN 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'IN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OUT 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자동/수동 유무' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA900', @level2type=N'COLUMN',@level2name=N'AUTO_YN'
GO
