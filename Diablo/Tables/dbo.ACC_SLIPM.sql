USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_SLIPM](
	[SLIP_MK_DAY] [char](8) NOT NULL,
	[SLIP_MK_SEQ] [smallint] NOT NULL,
	[DEPT_CD] [varchar](10) NULL,
	[EMP_NO] [varchar](10) NULL,
	[SLIP_FG] [char](1) NULL,
	[JUNL_FG] [varchar](2) NULL,
	[INS_DT] [datetime] NULL,
	[DZ_SEND_DT] [datetime] NULL,
 CONSTRAINT [PK_ACC_SLIPM] PRIMARY KEY CLUSTERED 
(
	[SLIP_MK_DAY] ASC,
	[SLIP_MK_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_SLIPM] ADD  DEFAULT (getdate()) FOR [INS_DT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 입금, 2 : 출금, 3 : 대체' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_SLIPM', @level2type=N'COLUMN',@level2name=N'SLIP_FG'
GO
