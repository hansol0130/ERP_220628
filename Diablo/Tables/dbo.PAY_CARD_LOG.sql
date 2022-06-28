USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_CARD_LOG](
	[PAY_SEQ] [int] NOT NULL,
	[EXP_DATE] [varchar](4) NULL,
	[INSTALLMENT] [int] NULL,
 CONSTRAINT [PK_PAY_CARD_LOG] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_CARD_LOG]  WITH CHECK ADD  CONSTRAINT [FK__PAY_CARD___PAY_S__2DD1C37F] FOREIGN KEY([PAY_SEQ])
REFERENCES [dbo].[PAY_MASTER_damo] ([PAY_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAY_CARD_LOG] CHECK CONSTRAINT [FK__PAY_CARD___PAY_S__2DD1C37F]
GO
