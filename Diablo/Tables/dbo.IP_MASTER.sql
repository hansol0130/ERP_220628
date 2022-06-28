USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IP_MASTER](
	[IP_TYPE] [int] NOT NULL,
	[IP_CODE] [int] NOT NULL,
	[CONNECT_CODE] [varchar](10) NULL,
	[IP_NUMBER] [varchar](15) NULL,
	[COM_NUMBER] [varchar](10) NULL,
	[COM_REMARK] [varchar](20) NULL,
	[COM_OFFICE_VER] [varchar](20) NULL,
	[COM_HANGLE_VER] [varchar](20) NULL,
 CONSTRAINT [PK_IP_MASTER] PRIMARY KEY CLUSTERED 
(
	[IP_TYPE] ASC,
	[IP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이피타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'IP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'IP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할당코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'CONNECT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이피번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'IP_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컴퓨터번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'COM_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컴퓨터비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'COM_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'오피스버전' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'COM_OFFICE_VER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글버전' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER', @level2type=N'COLUMN',@level2name=N'COM_HANGLE_VER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이피관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IP_MASTER'
GO
