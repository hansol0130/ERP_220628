USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POL_MASTER](
	[MASTER_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[TARGET] [char](1) NOT NULL,
	[POL_TYPE] [char](1) NOT NULL,
	[POL_STATE] [char](1) NOT NULL,
	[SUBJECT] [varchar](400) NOT NULL,
	[POL_DESC] [text] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[OPEN_DATE] [datetime] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[DEL_FLAG] [char](1) NOT NULL,
 CONSTRAINT [PK_POL_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[POL_MASTER] ADD  CONSTRAINT [DF_POL_MASTER_TARGET]  DEFAULT ('3') FOR [TARGET]
GO
ALTER TABLE [dbo].[POL_MASTER] ADD  CONSTRAINT [DF_POL_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[POL_MASTER] ADD  CONSTRAINT [DF_POL_MASTER_DEL_FALG]  DEFAULT ('N') FOR [DEL_FLAG]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문마스터번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 비회원, 2 : 회원, 3 : 내부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 전체평가, 2 : 가이드평가, 3 : 호텔평가, 4 : 식사평가, 5 : 고객평가, 6 : 이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'POL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 진행중, 2 : 종료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'POL_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'POL_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨자발표일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'OPEN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y:삭제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER', @level2type=N'COLUMN',@level2name=N'DEL_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_MASTER'
GO
