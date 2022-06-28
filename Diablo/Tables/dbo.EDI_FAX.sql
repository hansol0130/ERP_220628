USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_FAX](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[EDI_FAX_SEQ] [int] NOT NULL,
	[FAX_SEQ] [varchar](17) NULL,
 CONSTRAINT [PK_EDI_FAX] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC,
	[EDI_FAX_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_FAX]  WITH CHECK ADD  CONSTRAINT [R_334] FOREIGN KEY([EDI_CODE])
REFERENCES [dbo].[EDI_MASTER_damo] ([EDI_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EDI_FAX] CHECK CONSTRAINT [R_334]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_FAX', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서팩스순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_FAX', @level2type=N'COLUMN',@level2name=N'EDI_FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_FAX', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부팩스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_FAX'
GO
