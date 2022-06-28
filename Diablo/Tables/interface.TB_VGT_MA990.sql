USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_MA990](
	[LINK_NO] [int] IDENTITY(1,1) NOT NULL,
	[ANCLY_SEQNO] [int] NOT NULL,
	[RSV_STATUS_CD] [varchar](4) NOT NULL,
	[REG_DATE] [datetime] NULL,
	[IN_DATE] [datetime] NULL,
	[OUT_DATE] [datetime] NULL,
	[AUTO_YN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[LINK_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_MA990] ADD  CONSTRAINT [DF_TB_VGT_MA990_REG_DATE]  DEFAULT (getdate()) FOR [REG_DATE]
GO
ALTER TABLE [interface].[TB_VGT_MA990] ADD  DEFAULT ('Y') FOR [AUTO_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LINK 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'LINK_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가서비스 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'ANCLY_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 상태 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'RSV_STATUS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'REG_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리 시작' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'IN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리 종료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자동/수동 유무' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA990', @level2type=N'COLUMN',@level2name=N'AUTO_YN'
GO
