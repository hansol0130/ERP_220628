USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BREAK_REASON](
	[AGT_CODE] [varchar](10) NOT NULL,
	[REASON_SEQ] [int] NOT NULL,
	[PRO_TYPE] [char](1) NULL,
	[REASON_REMARK] [varchar](50) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_BREAK_RESON] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[REASON_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사유순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'REASON_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사유명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'REASON_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위반사유관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BREAK_REASON'
GO
