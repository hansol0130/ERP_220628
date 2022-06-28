USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CONNECT](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[SUP_CODE] [varchar](10) NOT NULL,
	[CONNECT_CODE] [varchar](20) NOT NULL,
	[SHOW_YN] [char](1) NULL,
	[PROVIDER_CITY_CODE] [varchar](10) NOT NULL,
 CONSTRAINT [PK_HTL_CONNECT] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[SUP_CODE] ASC,
	[CONNECT_CODE] ASC,
	[PROVIDER_CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HTL_CONNECT]  WITH CHECK ADD  CONSTRAINT [R_205] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[HTL_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HTL_CONNECT] CHECK CONSTRAINT [R_205]
GO
ALTER TABLE [dbo].[HTL_CONNECT]  WITH CHECK ADD  CONSTRAINT [R_206] FOREIGN KEY([SUP_CODE])
REFERENCES [dbo].[SUP_MASTER] ([SUP_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HTL_CONNECT] CHECK CONSTRAINT [R_206]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연결코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT', @level2type=N'COLUMN',@level2name=N'CONNECT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급처도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT', @level2type=N'COLUMN',@level2name=N'PROVIDER_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔연결코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_CONNECT'
GO
