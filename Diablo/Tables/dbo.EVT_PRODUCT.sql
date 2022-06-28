USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_PRODUCT](
	[EVT_SEQ] [int] NOT NULL,
	[MASTER_CODE] [varchar](20) NOT NULL,
	[DISPLAY_ORDER] [int] NULL,
	[REMARK] [varchar](30) NULL,
 CONSTRAINT [PK_EVT_PRODUCT] PRIMARY KEY CLUSTERED 
(
	[EVT_SEQ] ASC,
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PRODUCT', @level2type=N'COLUMN',@level2name=N'EVT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PRODUCT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PRODUCT', @level2type=N'COLUMN',@level2name=N'DISPLAY_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PRODUCT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트행사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PRODUCT'
GO
