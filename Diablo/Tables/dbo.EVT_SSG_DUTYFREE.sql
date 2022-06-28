USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_SSG_DUTYFREE](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [varchar](20) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_EVT_SSG_DUTYFREE] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'신세계면세쿠폰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SSG_DUTYFREE'
GO
