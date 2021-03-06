USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_APPROVAL_TEMPLATE](
	[DOC_TYPE] [dbo].[PUB_CODE] NOT NULL,
	[DETAIL_TYPE] [varchar](1) NOT NULL,
	[DUTY_CODE] [char](1) NOT NULL,
	[APP_TYPE] [char](1) NOT NULL,
	[FINAL_DUTY_TYPE] [dbo].[PUB_CODE] NULL,
 CONSTRAINT [PK_EDI_APPROVAL_TEMPLET] PRIMARY KEY CLUSTERED 
(
	[DOC_TYPE] ASC,
	[DETAIL_TYPE] ASC,
	[DUTY_CODE] ASC,
	[APP_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전결사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL_TEMPLATE'
GO
