USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_CODE](
	[CD_FG] [char](4) NOT NULL,
	[CD] [varchar](20) NOT NULL,
	[CD_NM] [varchar](40) NULL,
	[DZ_CODE] [varchar](40) NULL,
	[DZ_NAME] [varchar](40) NULL,
	[REMARK] [varchar](100) NULL,
	[DEL_YN] [char](1) NULL,
 CONSTRAINT [PK_ACC_CODE] PRIMARY KEY CLUSTERED 
(
	[CD_FG] ASC,
	[CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_CODE] ADD  DEFAULT ('N') FOR [DEL_YN]
GO
