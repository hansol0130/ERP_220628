USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_SPECIAL](
	[SPC_NO] [int] IDENTITY(1,1) NOT NULL,
	[NO1] [varchar](4) NULL,
	[NO2] [varchar](4) NULL,
	[NO3] [varchar](4) NULL,
	[CUS_NO] [int] NULL,
	[CONNECT_CODE] [char](7) NULL,
	[REMARK] [nvarchar](100) NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[USE_YN] [char](1) NULL,
 CONSTRAINT [PK_CUS_SPECIAL] PRIMARY KEY CLUSTERED 
(
	[SPC_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_SPECIAL] ADD  CONSTRAINT [DEF_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[CUS_SPECIAL] ADD  CONSTRAINT [DF__CUS_SPECI__USE_Y__5085AF9D]  DEFAULT ('Y') FOR [USE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'SPC_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'NO1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'NO2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'NO3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'CONNECT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특별고객관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SPECIAL'
GO
