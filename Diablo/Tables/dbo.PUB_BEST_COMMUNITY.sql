USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_COMMUNITY](
	[PRO_TYPE] [varchar](2) NOT NULL,
	[A_TYPE] [varchar](2) NOT NULL,
	[REG_SEQ] [int] NOT NULL,
	[CODE_TYPE] [int] NOT NULL,
	[CODE] [varchar](20) NOT NULL,
	[CODE_SEQ] [int] NULL,
	[ORDER_SEQ] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_PUB_BEST_COMMUNITY] PRIMARY KEY CLUSTERED 
(
	[PRO_TYPE] ASC,
	[A_TYPE] ASC,
	[CODE_TYPE] ASC,
	[REG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 상품평, 2 : 여행후기, 3 : 참좋은여행기, 4 : 참좋은여행기_일본' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_COMMUNITY', @level2type=N'COLUMN',@level2name=N'CODE_TYPE'
GO
