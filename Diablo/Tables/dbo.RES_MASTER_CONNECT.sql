USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_MASTER_CONNECT](
	[RES_CODE] [varchar](20) NOT NULL,
	[CON_TYPE] [varchar](2) NOT NULL,
	[CON_RES_CODE] [varchar](20) NOT NULL,
 CONSTRAINT [PK_RES_MASTER_CONNECT] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[CON_TYPE] ASC,
	[CON_RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'키 더미' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'CON_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상대 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'CON_RES_CODE'
GO
