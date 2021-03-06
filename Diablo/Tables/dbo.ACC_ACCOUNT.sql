USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_ACCOUNT](
	[USE_ACC_CD] [varchar](10) NOT NULL,
	[ACC_NM] [varchar](50) NULL,
	[SITE_CD_CHK] [char](1) NULL,
	[DEPT_CD_CHK] [char](1) NULL,
	[EMP_NO_CHK] [char](1) NULL,
	[PRO_CODE_CHK] [char](1) NULL,
	[ACC_NO_CHK] [char](1) NULL,
	[FG_NM1_CHK] [char](1) NULL,
	[FG_NM2_CHK] [char](1) NULL,
	[FG_NM3_CHK] [char](1) NULL,
	[DEL_YN] [char](1) NULL,
 CONSTRAINT [PK_ACC_ACCOUNT] PRIMARY KEY CLUSTERED 
(
	[USE_ACC_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [SITE_CD_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [DEPT_CD_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [EMP_NO_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [PRO_CODE_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [ACC_NO_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [FG_NM1_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [FG_NM2_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [FG_NM3_CHK]
GO
ALTER TABLE [dbo].[ACC_ACCOUNT] ADD  DEFAULT ('N') FOR [DEL_YN]
GO
