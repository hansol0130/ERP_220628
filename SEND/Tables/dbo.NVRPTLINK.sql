USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVRPTLINK](
	[CAMPAIGN_NO] [numeric](15, 0) NOT NULL,
	[LINK_SEQ] [numeric](3, 0) NOT NULL,
	[REPORT_DT] [char](8) NOT NULL,
	[REPORT_TM] [char](2) NOT NULL,
	[LINK_CNT] [numeric](10, 0) NULL,
	[LINK_OCNT] [numeric](10, 0) NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
 CONSTRAINT [PK_NVRPTLINK] PRIMARY KEY CLUSTERED 
(
	[CAMPAIGN_NO] ASC,
	[RESULT_SEQ] ASC,
	[LINK_SEQ] ASC,
	[REPORT_DT] ASC,
	[REPORT_TM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVRPTLINK]  WITH CHECK ADD  CONSTRAINT [FK_LINKTRACE_RPTLINK] FOREIGN KEY([CAMPAIGN_NO], [LINK_SEQ])
REFERENCES [dbo].[NVLINKTRACE] ([CAMPAIGN_NO], [LINK_SEQ])
GO
ALTER TABLE [dbo].[NVRPTLINK] CHECK CONSTRAINT [FK_LINKTRACE_RPTLINK]
GO
