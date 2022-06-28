USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_TAX](
	[TICKET] [varchar](10) NOT NULL,
	[TAX_PRICE] [float] NULL,
	[TAX_CODE] [varchar](2) NULL,
	[TAX_SEQ] [int] NOT NULL,
 CONSTRAINT [PK_DSR_TAX] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC,
	[TAX_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_TAX]  WITH CHECK ADD  CONSTRAINT [FK_DSR_TAX_DSR_TICKET] FOREIGN KEY([TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DSR_TAX] CHECK CONSTRAINT [FK_DSR_TAX_DSR_TICKET]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TAX', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX AMOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TAX', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TAX', @level2type=N'COLUMN',@level2name=N'TAX_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세금번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TAX', @level2type=N'COLUMN',@level2name=N'TAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR세금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TAX'
GO
