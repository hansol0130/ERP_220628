USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_RESERVE](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[EDI_RES_SEQ] [int] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
 CONSTRAINT [PK_EDI_RESERVE] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC,
	[EDI_RES_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_RESERVE]  WITH CHECK ADD  CONSTRAINT [R_338] FOREIGN KEY([EDI_CODE])
REFERENCES [dbo].[EDI_MASTER_damo] ([EDI_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EDI_RESERVE] CHECK CONSTRAINT [R_338]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_RESERVE', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_RESERVE', @level2type=N'COLUMN',@level2name=N'EDI_RES_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_RESERVE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_RESERVE'
GO
