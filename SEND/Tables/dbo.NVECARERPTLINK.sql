USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARERPTLINK](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[LINK_SEQ] [numeric](2, 0) NOT NULL,
	[REPORT_DT] [char](8) NOT NULL,
	[REPORT_TM] [char](2) NOT NULL,
	[LINK_CNT] [numeric](10, 0) NULL,
	[LINK_OCNT] [numeric](10, 0) NULL,
 CONSTRAINT [PK_NVECARERPTLINK] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[RESULT_SEQ] ASC,
	[LINK_SEQ] ASC,
	[REPORT_DT] ASC,
	[REPORT_TM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECARERPTLINK]  WITH CHECK ADD  CONSTRAINT [FK_ELT_ECARERPTLINK] FOREIGN KEY([ECARE_NO], [LINK_SEQ])
REFERENCES [dbo].[NVECARELINKTRACE] ([ECARE_NO], [LINK_SEQ])
GO
ALTER TABLE [dbo].[NVECARERPTLINK] CHECK CONSTRAINT [FK_ELT_ECARERPTLINK]
GO
