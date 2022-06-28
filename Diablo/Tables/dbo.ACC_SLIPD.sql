USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_SLIPD](
	[SLIP_MK_DAY] [char](8) NOT NULL,
	[SLIP_MK_SEQ] [smallint] NOT NULL,
	[SLIP_DET_SEQ] [smallint] NOT NULL,
	[USE_ACC_CD] [varchar](10) NULL,
	[DC_FG] [char](1) NULL,
	[DEB_AMT_W] [numeric](12, 0) NULL,
	[CRE_AMT_W] [numeric](12, 0) NULL,
	[REMARK] [varchar](200) NULL,
	[SITE_CD] [varchar](10) NULL,
	[DEPT_CD] [varchar](10) NULL,
	[EMP_NO] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[SAVE_ACC_NO] [varchar](20) NULL,
	[FG_NM1] [varchar](40) NULL,
	[FG_NM2] [varchar](40) NULL,
	[FG_NM3] [varchar](40) NULL,
	[INS_EMP_NO] [varchar](10) NULL,
	[INS_DT] [datetime] NULL,
 CONSTRAINT [PK_ACC_SLIPD] PRIMARY KEY CLUSTERED 
(
	[SLIP_MK_DAY] ASC,
	[SLIP_MK_SEQ] ASC,
	[SLIP_DET_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_SLIPD] ADD  DEFAULT (getdate()) FOR [INS_DT]
GO
ALTER TABLE [dbo].[ACC_SLIPD]  WITH CHECK ADD  CONSTRAINT [FK_ACC_SLIPD_REF_ACC_SLIPM] FOREIGN KEY([SLIP_MK_DAY], [SLIP_MK_SEQ])
REFERENCES [dbo].[ACC_SLIPM] ([SLIP_MK_DAY], [SLIP_MK_SEQ])
GO
ALTER TABLE [dbo].[ACC_SLIPD] CHECK CONSTRAINT [FK_ACC_SLIPD_REF_ACC_SLIPM]
GO
