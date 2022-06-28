USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSH_MASTER](
	[MASTER_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[TARGET] [int] NOT NULL,
	[SUBJECT] [varchar](200) NOT NULL,
	[DESCRIPTION] [varchar](200) NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[OPEN_DATE] [datetime] NULL,
	[ENTER_WAY] [varchar](200) NULL,
	[FREE_GIFT1] [varchar](200) NULL,
	[FREE_GIFT2] [varchar](200) NULL,
	[FREE_GIFT3] [varchar](200) NULL,
	[FREE_GIFT4] [varchar](200) NULL,
	[FREE_GIFT5] [varchar](200) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_RSH_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상( 0 : 전체, 1 : 회원 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'끝일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발표일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'OPEN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'응모방법' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'ENTER_WAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경품1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'FREE_GIFT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경품2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'FREE_GIFT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경품3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'FREE_GIFT3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경품4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'FREE_GIFT4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경품5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'FREE_GIFT5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리서치 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_MASTER'
GO
