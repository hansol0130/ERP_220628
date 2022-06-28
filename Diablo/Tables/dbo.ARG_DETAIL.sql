USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_DETAIL](
	[ARG_CODE] [varchar](12) NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[PAR_GRP_SEQ_NO] [int] NULL,
	[TITLE] [varchar](200) NULL,
	[CONTENT] [nvarchar](max) NULL,
	[ARG_TYPE] [int] NULL,
	[ARG_STATUS] [int] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NIGHTS] [int] NULL,
	[DAY] [int] NULL,
	[ADT_COUNT] [int] NULL,
	[CHD_COUNT] [int] NULL,
	[INF_COUNT] [int] NULL,
	[FOC_COUNT] [int] NULL,
	[CFM_CODE] [dbo].[EMP_CODE] NULL,
	[CFM_DATE] [datetime] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_ARG_DETAIL] PRIMARY KEY CLUSTERED 
(
	[ARG_CODE] ASC,
	[GRP_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARG_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_409] FOREIGN KEY([ARG_CODE])
REFERENCES [dbo].[ARG_MASTER] ([ARG_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ARG_DETAIL] CHECK CONSTRAINT [R_409]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'ARG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'PAR_GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 수배요청서, 2: 수배확정서, 3: 인보이스, 4 : 인보이스확정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'ARG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 수배요청, 2 : 수배확정, 3 : 수배취소, 4 : 수배확정취소, 5 : 인보이스발행, 6 : 인보이스확정, 7 : 인보이스취소, 8 : 인보이스확정취소, 9 : 정산결재, 10 : 정산지급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'ARG_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'박수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'NIGHTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'ADT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'CHD_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'INF_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FOC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'FOC_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 세부사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_DETAIL'
GO
