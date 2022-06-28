USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[SHBANK_CODE](
	[CODE] [char](10) NOT NULL,
	[CUS_NO] [int] NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_SHBANK_CODE] PRIMARY KEY CLUSTERED 
(
	[CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'난수코드' , @level0type=N'SCHEMA',@level0name=N'onetime', @level1type=N'TABLE',@level1name=N'SHBANK_CODE', @level2type=N'COLUMN',@level2name=N'CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원NO' , @level0type=N'SCHEMA',@level0name=N'onetime', @level1type=N'TABLE',@level1name=N'SHBANK_CODE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트신청일' , @level0type=N'SCHEMA',@level0name=N'onetime', @level1type=N'TABLE',@level1name=N'SHBANK_CODE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
